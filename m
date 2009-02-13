Return-Path: <linux-kernel-owner+w=401wt.eu-S1759785AbZBMUCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbZBMUCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZBMUCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:02:24 -0500
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:5353 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZBMUCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:02:22 -0500
Date: Fri, 13 Feb 2009 21:06:35 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Risto Suominen <risto.suominen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, geert@linux-m68k.org,
       adaplas@pol.net, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
Message-Id: <20090213210635.d094ffc8.krzysztof.h1@poczta.fm>
In-Reply-To: <46e1c7760902121312o1476e734xc1fc1d6e11ce4d2e@mail.gmail.com>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	<Pine.LNX.4.64.0901240951110.13803@anakin>
	<46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
	<Pine.LNX.4.64.0901241425310.13803@anakin>
	<46e1c7760901240649v1e45bbb1v8c9997f236a3ec4c@mail.gmail.com>
	<46e1c7760902101337qe239336n9ef2652a47f89aed@mail.gmail.com>
	<46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
	<20090211142409.b88c577e.akpm@linux-foundation.org>
	<46e1c7760902121312o1476e734xc1fc1d6e11ce4d2e@mail.gmail.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 78e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009 23:12:26 +0200
Risto Suominen <risto.suominen@gmail.com> wrote:

> 2009/2/12 Andrew Morton <akpm@linux-foundation.org>:
> >> ---
> >> The testing is done on kernel version 2.6.18.
> >
> > That's a truly ancient kernel.  Is the patch needed on current kernels?
> > Does it work correctly in current kernels?
> >
> It does not on 2.6.24. The patch works.
> 

I have tested two cards with the hardware cursor: 
Permedia 2 (pm2fb) and Voodoo-3 (tdfxfb).

Both cards use the hardware cursor and both does
not produce the bug you have described.
I have used the Xorg version 7.2 included in the
Slackware 12 and a current git version of the kernel
(updated two days ago).

I do not have the ATI Mach64 card to test it.
I will test my cards with the kernel 2.6.24.

Either, this bug is related only to the atyfb driver
or it was solved in the current kernel.
I looked into the atyfb driver code and I did not
 see anything suspicious there.

Kind regards,
Krzysztof


----------------------------------------------------------------------
Wyslij kartke walentynkowa
Kliknij >>> http://link.interia.pl/f205f

