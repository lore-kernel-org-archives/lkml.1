Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbXKJPmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbXKJPmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXKJPmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:42:05 -0500
Received: from mx1.suse.de ([195.135.220.2]:60995 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbXKJPmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:42:02 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 5/13] Char: nozomi, ioctls cleanup
Date: Sat, 10 Nov 2007 16:41:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <1390286880006050.slaby@pripojeni.net>
In-Reply-To: <1390286880006050.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101641.59587.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:46:11, you (Jiri Slaby) wrote:
> nozomi, ioctls cleanup
> 
> - init tty_wait
> - don't forget to wake up tiocmiwait waiters
> - convert the whole tiocmiwait into wait_event_interruptible
> - don't check for cmd == TIOCGICOUNT in ntty_ioctl_tiocgicount, as it's
>   expected to be it when we call the function, also pass internal
>   structures (port, argp) directly instead of ioctl params
> - remove TIOCMGET, TIOCMSET, TIOCMBIC, TIOCMBIS as it is never invoked by
>   tty layer this way, add ntty_tiocmget into tty ops instead

Sadfully my knowledge of the tty layer is still too low to comment anything
usefull, but all sound and looks reasonable to me.
And i did a special testrun after this patch and couldn't see any problems.

So, applied without change.

Thanks,
Frank

