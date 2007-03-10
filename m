Return-Path: <linux-kernel-owner+w=401wt.eu-S1767602AbXCJADh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767602AbXCJADh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767603AbXCJADh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:03:37 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:58254 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767602AbXCJADg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:03:36 -0500
Date: Sat, 10 Mar 2007 01:01:52 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/9] signalfd/timerfd v1 - anonymoush inode source ...
In-Reply-To: <Pine.LNX.4.64.0703091529100.3761@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.61.0703100101380.8799@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0703091529100.3761@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 9 2007 15:39, Davide Libenzi wrote:
>
>This patch add an anonymous inode source, to be used for files that need 
>and inode only in order to create a file*. We do not care of having an 
>inode for each file, and we do not even care of having different names in 
>the associated dentries (dentry names will be same for classes of file*).
>This allow code reuse, and will be used by epoll, signalfd and timerfd 
>(and whatever else there'll be).

Perhaps procfs?



Jan
-- 
