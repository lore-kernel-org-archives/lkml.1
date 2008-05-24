Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYEXLzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYEXLzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 07:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYEXLzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 07:55:40 -0400
Received: from prof.cs.pub.ro ([141.85.37.3]:44116 "EHLO mail.cs.pub.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbYEXLzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 07:55:39 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 May 2008 07:55:39 EDT
From: Octavian Purdila <tavi@cs.pub.ro>
Organization: Politehnica University of Bucharest
To: linux-kernel@vger.kernel.org
Subject: [announce] linux kernel library project
Date: Sat, 24 May 2008 14:44:06 +0300
User-Agent: KMail/1.9.9
Cc: Lucian Grijincu <lucian.grijincu@gmail.com>,
       Stefania Costache <shteph@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805241444.06791.tavi@cs.pub.ro>
X-mail.cs.pub.ro-MailScanner: Found to be clean
X-mail.cs.pub.ro-MailScanner-SpamCheck: not spam, SpamAssassin (score=0.712,
	required 6, autolearn=not spam, BAYES_00 0.71)
X-mail.cs.pub.ro-MailScanner-From: tavi@cs.pub.ro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi everybody,

The purpose of the Linux Kernel Library project is to organize the Linux 
kernel code in a library which can be used in third party projects. It 
strives to be portable across hardware platforms, operating systems, as well 
as kernel and user-space environments.

The library prototype we developed was tested with a few applications 
(prototypes as well):
- portable FTP daemon (using the Apache Runtime Library) which can be used to 
read/write Linux filesystems
- windows filesystem driver for Linux filesystems

We also added (very incomplete) support for running the application code under 
valgrind to help us catch memory related bugs in the kernel code via a new 
SL*B allocator.

The modifications to the Linux kernel code are minimal and isolated, as
all modifications are done as a new architecture port. You can find the code 
in git repositories here:

http://ixlabs.cs.pub.ro/git/?p=lkl/linux-2.6;a=summary
http://ixlabs.cs.pub.ro/git/?p=lkl/lklftpd;a=summary
http://ixlabs.cs.pub.ro/git/?p=lkl/lklvfs;a=summary

Since the code is starting the bitrot, I thought of dropping an announce here 
to get your opinion and maybe a boost to this project - if there are people 
believing that there is value in this project.

We are eagerly waiting for your comments :)

Thanks,
Lucian, Stefania, Tavi


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

