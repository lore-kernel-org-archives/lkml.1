Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYLHNXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYLHNXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYLHNWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:22:52 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:45272 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbYLHNWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:22:51 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Artem Bityutskiy <dedekind@yandex.ru>
Subject: Re: [PATCH 1/1] fs: fix warning message with inserting a =?utf-8?q?single=09space?=
Date: Mon, 8 Dec 2008 14:24:28 +0100
User-Agent: KMail/1.9.9
Cc: Nick Andrew <nick@nick-andrew.net>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       linux-kernel@vger.kernel.org, apw@shadowen.org
References: <1228737252-31948-1-git-send-email-Hiroshi.DOYU@nokia.com> <20081208123517.GA3892@mail.local.tull.net> <493D1E15.6060001@yandex.ru>
In-Reply-To: <493D1E15.6060001@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812081424.29279.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 8. Dezember 2008 14:16:05 schrieb Artem Bityutskiy:
> Nick Andrew wrote:
> > On Mon, Dec 08, 2008 at 01:54:12PM +0200, Hiroshi DOYU wrote:
> >> -			printk(KERN_WARNING "%s: %s passed in a files array"
> >> +			printk(KERN_WARNING "%s: %s passed in a files array "
> >>  				"with an index of 1!\n", __func__,
> >>  				s->s_type->name);
> > 
> > Yep. These look like the same kind of thing:
> > 
> > arch/powerpc/platforms/cell/iommu.c +1109
> >                                 pr_debug("iommu: hash window doesn't fit in"
> >                                          "real DMA window\n");
> 
> Do we have such kind of check in checkpatch.pl? Would be useful.

No, it wouldn't. A kernel message should be grepable. So, when in doubt,
screw the screen width limit. Don't make making ungreppable messages
easier.

	Regards
		Oliver
