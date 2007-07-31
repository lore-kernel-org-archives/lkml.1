Return-Path: <linux-kernel-owner+w=401wt.eu-S967537AbXGaDbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967537AbXGaDbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXGaDaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:30:55 -0400
Received: from ms-smtp-06.texas.rr.com ([24.93.47.45]:37206 "EHLO
	ms-smtp-06.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbXGaDay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:30:54 -0400
Subject: Kernel Build Failure
From: Chris Holvenstot <saltydog@houston.rr.com>
To: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 30 Jul 2007 22:31:00 -0500
Message-Id: <1185852660.30600.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am having a problem, likely caused by the vacuum between my ears, but
I thought that a few of you would find it recreational to tear up an
inexperienced user for doing dumb things.  

I have what is quickly becoming a "un-ubuntu" 7.04 system - as time goes
on I seem to be replacing the standard distribution with "alternative"
components - this past weekend I replaced the kernel because the one
shipped with Ubuntu was not cutting it with the new SATA drives I
recently purchased.

So I downloaded the 2.6.22.1 kernel sources and set out to build a new
kernel.  For the most part I left things pretty much as they shipped
when running the menuconfig tool and an hour or so later I had a
functioning kernel which did a decent job supporting my new hard drives
(I still have a slight problem with soft resets which seems to go away
when I turn NCQ down to zero)

While I was researching the SATA issue I noted a comment on the mailing
list that having a few more people build and run your RC1 kernels wold
be desirable.  So I said, why not?   I may still be new to Linux and C
but I was an MVS Sysprog and assembly language programmer for 25 years
and if nothing else I have strong troubleshooting skills and a
understanding of how an operating system works.

My target system for this activity was my "multi-purpose" AMD64 X2 based
home server - in addition to being my desktop, it also functions as the
family web server and even runs the sewing machine via an instance of
Windows running under VirtualBox.  The box is up 24x7 and gets a good
work out on a variety of tasks, but if it goes down so be it.  

However, I think that my process for building an RC1 kernel must be
flawed, and as much as I poked around I can not spot what I am doing
wrong.  

I take a virgin set of 2.6.22.1 sources.  

To this I added the 2.6.23-rc1 patch set.  The patch verified and
applied without generating any error messages.

The only change I made with the menuconfig tool from 2.6.22.1 was to
change the generated kernel name.

I ran make and received the following error:

CC [M]  net/netfilter/nf_conntrack_proto_sctp.o
net/netfilter/nf_conntrack_proto_sctp.c: In function ‘sctp_new’:
net/netfilter/nf_conntrack_proto_sctp.c:436: error: implicit declaration
of function ‘DEBUGP’
make[2]: *** [net/netfilter/nf_conntrack_proto_sctp.o] Error 1
make[1]: *** [net/netfilter] Error 2
make: *** [net] Error 

Any suggestions as to what I might be doing wrong would be appreciated.

Thanks

Chris






