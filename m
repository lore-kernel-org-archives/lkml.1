Return-Path: <linux-kernel-owner+w=401wt.eu-S1767679AbXCJAS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767679AbXCJAS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767680AbXCJAS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:18:29 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:44239 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767679AbXCJAS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:18:28 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 9 Mar 2007 16:18:25 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/9] signalfd/timerfd v1 - anonymoush inode source ...
In-Reply-To: <Pine.LNX.4.61.0703100101380.8799@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0703091614230.3761@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091529100.3761@alien.or.mcafeemobile.com>
 <Pine.LNX.4.61.0703100101380.8799@yvahk01.tjqt.qr>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Jan Engelhardt wrote:

> 
> On Mar 9 2007 15:39, Davide Libenzi wrote:
> >
> >This patch add an anonymous inode source, to be used for files that need 
> >and inode only in order to create a file*. We do not care of having an 
> >inode for each file, and we do not even care of having different names in 
> >the associated dentries (dentry names will be same for classes of file*).
> >This allow code reuse, and will be used by epoll, signalfd and timerfd 
> >(and whatever else there'll be).
> 
> Perhaps procfs?

But procfs needs real inodes and dentries. The reason of the anonymous 
inode source patch, is to 1) avoid code duplication (setup code is 
basically identical for all those file types) 2) save memory for inodes in 
all those pseudo-files like epoll, signalfd, timerfd, ...



- Davide


