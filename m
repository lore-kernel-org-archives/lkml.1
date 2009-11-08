Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZKHVbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZKHVbw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 16:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbZKHVbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 16:31:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbZKHVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 16:31:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [RFC, PATCH 0/7] net, compat_ioctl: move handlers to net/socket.c
Date: Sun, 8 Nov 2009 22:31:47 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, hch@lst.de, netdev@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
References: <1257530949-9695-1-git-send-email-arnd@arndb.de> <20091106.204753.223665411.davem@davemloft.net>
In-Reply-To: <20091106.204753.223665411.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911082231.48060.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+QM+zyzd7AMMlygs2+sRTyjexihgIPmVeV8gq
 CxmbvvTzKoGka1wWvMIAtrw19ZRj/sI0pZGM4LQvP+JySRFyGH
 f0t9JV6w73MojL7G6+JEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 November 2009, David Miller wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Fri,  6 Nov 2009 19:09:02 +0100
> 
> > This cleans up some of the socket ioctl handling by moving it
> > from fs/compat_ioctl.c to net/socket.c. The code is still untested,
> > so this is an RFC for now. If you're happy with it, I'll do some
> > testing to see if everything still works.
> > 
> > This series is a prerequisite for cleaning up the rest of
> > compat_ioctl.c, saving some 30kb of kernel memory in the end.
> > 
> > The first four patches are probably worthwhile independently,
> > because they fix some bugs in compat_ioctl handling.
> > There is some obvious conflict with the ATM patch I sent
> > independently today. That one should probably be worked out
> > first.
> 
> This looks great, all applied.  Please make the fixups recommended
> to you in the feedback as followon patches.

Thanks! Two patches follow.

Any opinion on how to proceed with the ATM stuff? From my
point of view, I'm fine with having moved it out of fs/compat_ioctl.c,
but it's still a bit silly to have two half-complete implementations.

> Also, I added the following cure after your patch series:
> 
> net: compat: No need to define IFHWADDRLEN and IFNAMSIZ twice.
> 
> It's defined colloqually in linux/if.h and linux/compat.h
> includes that.

ok.

	Arnd <><
