Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbXI0Kfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbXI0Kfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 06:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXI0Kfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 06:35:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:36573 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752191AbXI0Kfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 06:35:33 -0400
Cc: rdunlap@xenotime.net, akpm@linux-foundation.org, hch@lst.de,
       geoff@gclare.org.uk, tglx@linutronix.de, david@hardeman.nu,
       drepper@redhat.com, subrata@linux.vnet.ibm.com, corbet@lwn.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 27 Sep 2007 12:35:31 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0709261038550.25778@alien.or.mcafeemobile.com>
Message-ID: <20070927103531.184550@gmx.net>
MIME-Version: 1.0
References: <46FA0657.20700@gmx.net>
 <Pine.LNX.4.64.0709261038550.25778@alien.or.mcafeemobile.com>
Subject: Re: Man page for revised timerfd API
To: Davide Libenzi <davidel@xmailserver.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX196HfUkLmB6MTtleImH6GCbEzzNPdwa5DCWs2LnpT
 BTLHQg7eTmMs44nmXhreuY0oBYCwr3rYTFKw== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: JOKJZnMpeSEqQcf8EHUh8XV+IGRvb8BB
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,

A further question: what is the expected behavior in the
following scenario:

1. Create a timerfd and arm it.
2. Wait until M timer expirations have occurred
3. Modify the settings of the timer
4. Wait for N further timer expirations have occurred
5. read() from the timerfd

Does the buffer returned by the read() contain the value
N or (M+N)?  In other words, should modifying the timer
settings reset the expiration count to zero?

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

