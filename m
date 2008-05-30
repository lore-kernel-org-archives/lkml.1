Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYE3Ogo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYE3Ogo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 10:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYE3Ogh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 10:36:37 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:47236 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYE3Ogg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 10:36:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18496.4309.393775.511382@stoffel.org>
Date: Fri, 30 May 2008 10:36:05 -0400
From: "John Stoffel" <john@stoffel.org>
To: Rik van Riel <riel@redhat.com>
Cc: "John Stoffel" <john@stoffel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       eric.whitney@hp.com, linux-mm@kvack.org, npiggin@suse.de
Subject: Re: [PATCH 00/25] Vm Pageout Scalability Improvements (V8) -
 continued
In-Reply-To: <20080530102917.45cbca64@bree.surriel.com>
References: <20080529195030.27159.66161.sendpatchset@lts-notebook>
	<20080529131624.60772eb6.akpm@linux-foundation.org>
	<20080529162029.7b942a97@bree.surriel.com>
	<18496.1712.236440.420038@stoffel.org>
	<20080530102917.45cbca64@bree.surriel.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Rik> On Fri, 30 May 2008 09:52:48 -0400
Rik> "John Stoffel" <john@stoffel.org> wrote:

>> I haven't seen any performance numbers talking about how well this
>> stuff works on single or dual CPU machines with smaller amounts of
>> memory, or whether it's worth using on these machines at all?
>> 
>> The big machines with lots of memory and lots of CPUs are certainly
>> becoming more prevalent, but for my home machine with 4Gb RAM and dual
>> core, what's the advantage?  
>> 
>> Let's not slow down the common case for the sake of the bigger guys if
>> possible.

Rik> I wouldn't call your home system with 4GB RAM "small".

*grin* me either in some ways.  But my other main linux box, which
acts as an NFS server has 2Gb of RAM, but a pair of PIII Xeons at
550mhz.  This is the box I'd be worried about in some ways, since it
handles a bunch of stuff like backups, mysql, apache, NFS server,
etc.  

Rik> After all, the VM that Linux currently has was developed mostly
Rik> on machines with less than 1GB of RAM and later encrusted in
Rik> bandaids to make sure the large systems did not fail too badly.

Sure, I understand.  

Rik> As for small system performance, I believe that my patch series
Rik> should cause no performance regressions on those systems and has
Rik> a framework that allows us to improve performance on those
Rik> systems too.

Great!  It would be nice to just be able to track this nicely.

Rik> If you manage to break performance with my patch set somehow,
Rik> please let me know so I can fix it.  Something like the VM is
Rik> very subtle and any change is pretty much guaranteed to break
Rik> something, so I am very interested in feedback.

What are you using to test/benchmark your changes as you develop this
patchset?  What would you suggest as a test load to help check
performance?

John
