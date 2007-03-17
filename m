Return-Path: <linux-kernel-owner+w=401wt.eu-S1751553AbXCQVga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbXCQVga (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 17:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXCQVga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 17:36:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:65047 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbXCQVga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 17:36:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch 6/13] signal/timer/event fds v6 - timerfd core ...
Date: Sat, 17 Mar 2007 22:36:52 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <send-serie.davidel@xmailserver.org.9367.1174004538.6>
In-Reply-To: <send-serie.davidel@xmailserver.org.9367.1174004538.6>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703172236.52865.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19gkkXmftfDkoRQApWpg9ykdULoobXUGchVW4G
 Csp7/0UCZg9yNU32aqM9JDK4Yo5YENSufiz++67XgRE1JIXQe/
 VPSXFmMPlWXIqo6zBv1KA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2007 01:22:15 Davide Libenzi wrote:
> This patch introduces a new system call for timers events delivered
> though file descriptors. This allows timer event to be used with
> standard POSIX poll(2), select(2) and read(2). As a consequence of
> supporting the Linux f_op->poll subsystem, they can be used with
> epoll(2) too.

Half of my comments about signalfd also apply to the code in here.

	Arnd <><
