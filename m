Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZFGOVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZFGOVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZFGOUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:20:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39753 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753524AbZFGOUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:20:54 -0400
Date: Sun, 7 Jun 2009 15:21:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] IDE fixes
Message-ID: <20090607152151.3cb01901@lxorguk.ukuu.org.uk>
In-Reply-To: <200906071444.33047.bzolnier@gmail.com>
References: <200906071444.33047.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> index 99e33ef..4bc2c43 100644
> --- a/fs/partitions/check.c
> +++ b/fs/partitions/check.c


You seriously want to add code to the core partition handling logic
moments before release when we know we have all sorts of devices with
weird behaviours ?

This should be .31 stuff where we can take the time to see how it works
on all sorts of weird real world devices (eg those with 2K sector size)
and the like.

