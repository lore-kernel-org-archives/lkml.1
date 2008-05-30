Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYE3OaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYE3OaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 10:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYE3OaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 10:30:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbYE3OaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 10:30:01 -0400
Date: Fri, 30 May 2008 10:29:17 -0400
From: Rik van Riel <riel@redhat.com>
To: "John Stoffel" <john@stoffel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       eric.whitney@hp.com, linux-mm@kvack.org, npiggin@suse.de
Subject: Re: [PATCH 00/25] Vm Pageout Scalability Improvements (V8) -
 continued
Message-ID: <20080530102917.45cbca64@bree.surriel.com>
In-Reply-To: <18496.1712.236440.420038@stoffel.org>
References: <20080529195030.27159.66161.sendpatchset@lts-notebook>
	<20080529131624.60772eb6.akpm@linux-foundation.org>
	<20080529162029.7b942a97@bree.surriel.com>
	<18496.1712.236440.420038@stoffel.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 09:52:48 -0400
"John Stoffel" <john@stoffel.org> wrote:

> I haven't seen any performance numbers talking about how well this
> stuff works on single or dual CPU machines with smaller amounts of
> memory, or whether it's worth using on these machines at all?
> 
> The big machines with lots of memory and lots of CPUs are certainly
> becoming more prevalent, but for my home machine with 4Gb RAM and dual
> core, what's the advantage?  
> 
> Let's not slow down the common case for the sake of the bigger guys if
> possible.

I wouldn't call your home system with 4GB RAM "small".

After all, the VM that Linux currently has was developed
mostly on machines with less than 1GB of RAM and later
encrusted in bandaids to make sure the large systems did
not fail too badly.

As for small system performance, I believe that my patch
series should cause no performance regressions on those
systems and has a framework that allows us to improve
performance on those systems too.

If you manage to break performance with my patch set
somehow, please let me know so I can fix it.  Something
like the VM is very subtle and any change is pretty
much guaranteed to break something, so I am very interested
in feedback.

-- 
All rights reversed.
