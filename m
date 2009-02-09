Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbZBICi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbZBICi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 21:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbZBICis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 21:38:48 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:45983 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZBICir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 21:38:47 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 8 Feb 2009 18:38:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: mtk.manpages@gmail.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] timerfd add flags check
In-Reply-To: <cfd18e0f0902081834l55142925i1f2f068e4aa9b145@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902081836540.18839@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902081504380.18839@alien.or.mcafeemobile.com> <cfd18e0f0902081834l55142925i1f2f068e4aa9b145@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009, Michael Kerrisk wrote:

> On Mon, Feb 9, 2009 at 12:23 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > Like Michael requested, this patch adds a missing check for valid flags in
> > timerfd_settime(), and make it return EINVAL in case some extra bits are
> > set. If this is or not a -stable thing, it Greg decision.
> > Should be queued by Andrew for .30, unless -stable and Linus decide to
> > get it before, like Michael suggested.
> 
> When these two patches are applied against .29-rc3:
> 
> $ make
> [...]
>   CC      fs/timerfd.o
> fs/timerfd.c: In function 'sys_timerfd_create':
> fs/timerfd.c:190: error: implicit declaration of function 'invalid_clockid'
> make[1]: *** [fs/timerfd.o] Error 1
> make: *** [fs] Error 2

Yeah, I missed the posix-timers.h inclusion in timerfd.c, when I split the 
first patch into two separate ones. Will re-send tomorrow.


- Davide


