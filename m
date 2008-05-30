Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbYE3P2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbYE3P2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYE3P2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:28:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbYE3P2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:28:42 -0400
Date: Fri, 30 May 2008 11:27:52 -0400
From: Rik van Riel <riel@redhat.com>
To: "John Stoffel" <john@stoffel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       eric.whitney@hp.com, linux-mm@kvack.org, npiggin@suse.de
Subject: Re: [PATCH 00/25] Vm Pageout Scalability Improvements (V8) -
 continued
Message-ID: <20080530112752.66b6580f@bree.surriel.com>
In-Reply-To: <18496.4309.393775.511382@stoffel.org>
References: <20080529195030.27159.66161.sendpatchset@lts-notebook>
	<20080529131624.60772eb6.akpm@linux-foundation.org>
	<20080529162029.7b942a97@bree.surriel.com>
	<18496.1712.236440.420038@stoffel.org>
	<20080530102917.45cbca64@bree.surriel.com>
	<18496.4309.393775.511382@stoffel.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 10:36:05 -0400
"John Stoffel" <john@stoffel.org> wrote:

> Rik> If you manage to break performance with my patch set somehow,
> Rik> please let me know so I can fix it.  Something like the VM is
> Rik> very subtle and any change is pretty much guaranteed to break
> Rik> something, so I am very interested in feedback.
> 
> What are you using to test/benchmark your changes as you develop this
> patchset?  What would you suggest as a test load to help check
> performance?

Your normal workload.

I am doing some IO throughput, swap throughput and database tests,
however those are probably not representative of what YOU throw at
the VM.

There are no VM benchmarks that cover everything, so what is needed
most at this point is real world exposure.  I cannot promise that
the code is perfect; all I can promise is that I will try to fix
any performance issue that people find.

-- 
All rights reversed.
