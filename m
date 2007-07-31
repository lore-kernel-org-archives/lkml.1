Return-Path: <linux-kernel-owner+w=401wt.eu-S967266AbXGaD5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967266AbXGaD5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965044AbXGaD44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:56:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62815 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760193AbXGaD4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:56:55 -0400
Date: Mon, 30 Jul 2007 21:01:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chris Holvenstot <saltydog@houston.rr.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Kernel Build Failure
Message-Id: <20070730210101.d54fe629.randy.dunlap@oracle.com>
In-Reply-To: <1185852660.30600.35.camel@localhost>
References: <1185852660.30600.35.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007 22:31:00 -0500 Chris Holvenstot wrote:

> I am having a problem, likely caused by the vacuum between my ears, but
> I thought that a few of you would find it recreational to tear up an
> inexperienced user for doing dumb things.  
> 
> I have what is quickly becoming a "un-ubuntu" 7.04 system - as time goes
> on I seem to be replacing the standard distribution with "alternative"
> components - this past weekend I replaced the kernel because the one
> shipped with Ubuntu was not cutting it with the new SATA drives I
> recently purchased.
> 
> So I downloaded the 2.6.22.1 kernel sources and set out to build a new
> kernel.  For the most part I left things pretty much as they shipped
> when running the menuconfig tool and an hour or so later I had a
> functioning kernel which did a decent job supporting my new hard drives
> (I still have a slight problem with soft resets which seems to go away
> when I turn NCQ down to zero)
> 
> While I was researching the SATA issue I noted a comment on the mailing
> list that having a few more people build and run your RC1 kernels wold
> be desirable.  So I said, why not?   I may still be new to Linux and C
> but I was an MVS Sysprog and assembly language programmer for 25 years
> and if nothing else I have strong troubleshooting skills and a
> understanding of how an operating system works.
> 
> My target system for this activity was my "multi-purpose" AMD64 X2 based
> home server - in addition to being my desktop, it also functions as the
> family web server and even runs the sewing machine via an instance of
> Windows running under VirtualBox.  The box is up 24x7 and gets a good
> work out on a variety of tasks, but if it goes down so be it.  
> 
> However, I think that my process for building an RC1 kernel must be
> flawed, and as much as I poked around I can not spot what I am doing
> wrong.  
> 
> I take a virgin set of 2.6.22.1 sources.  
> 
> To this I added the 2.6.23-rc1 patch set.  The patch verified and
> applied without generating any error messages.
> 
> The only change I made with the menuconfig tool from 2.6.22.1 was to
> change the generated kernel name.
> 
> I ran make and received the following error:
> 
> CC [M]  net/netfilter/nf_conntrack_proto_sctp.o
> net/netfilter/nf_conntrack_proto_sctp.c: In function ‘sctp_new’:
> net/netfilter/nf_conntrack_proto_sctp.c:436: error: implicit declaration
> of function ‘DEBUGP’
> make[2]: *** [net/netfilter/nf_conntrack_proto_sctp.o] Error 1
> make[1]: *** [net/netfilter] Error 2
> make: *** [net] Error 
> 
> Any suggestions as to what I might be doing wrong would be appreciated.

Apply 2.6.23-rc1 to 2.6.22, not to 2.6.22.1.  The 2.6.2x.y -stable
series is a different branch of development.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
