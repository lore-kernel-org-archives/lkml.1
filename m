Return-Path: <linux-kernel-owner+w=401wt.eu-S1761466AbZFNAdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbZFNAdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 20:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758542AbZFNAdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 20:33:07 -0400
Received: from solo.fdn.fr ([80.67.169.19]:33141 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622AbZFNAdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 20:33:07 -0400
Date: Sun, 14 Jun 2009 02:33:05 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Anton Zinoviev <anton@lml.bas.bg>
Subject: Re: [PATCH] advertise KT_DEAD2
Message-ID: <20090614003305.GL5181@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	Anton Zinoviev <anton@lml.bas.bg>
References: <20090613125233.GH5181@const.famille.thibault.fr> <alpine.LFD.2.01.0906131707050.3237@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.01.0906131707050.3237@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds, le Sat 13 Jun 2009 17:07:31 -0700, a écrit :
> On Sat, 13 Jun 2009, Samuel Thibault wrote:
> >
> > In addition to KT_DEAD which has limited support for diacriticals, there
> > is KT_DEAD2 that can support 256 criticals, so let's advertise it in
> > <linux/keyboard.h>.
> 
> Can you do more of an explanation for this? KT_DEAD2 does not show up in a 
> kernel grep, so..

That's precisely why I'm defining it.  Other KT_* aren't usually
used from the kernel itself, but from userland.  The kernel part is
the k_dead2 function in drivers/char/keyboard.c, like k_dead is for
KT_DEAD, the relation being in the K_HANDLERS initializer, sorry for not
mentioning it in my first mail.

Samuel
