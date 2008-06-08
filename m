Return-Path: <linux-kernel-owner+w=401wt.eu-S1760167AbYFHKaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbYFHKaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 06:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbYFHK34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 06:29:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40776 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878AbYFHK34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 06:29:56 -0400
Date: Sun, 8 Jun 2008 07:29:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] v4l: saa7134: fix multiple clients access (and
 oops)
Message-ID: <20080608072942.59d495f8@gaivota>
In-Reply-To: <20080607224835.GA25025@joi>
References: <20080607224835.GA25025@joi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008 00:48:40 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> While looking for a reason of multiple oopses in empress_querycap as reported
> by kerneloops.org I noticed that only first open of device initializes
> struct_file->private_data properly. (Closing the device was broken too).
> 
> So initialize private_date and free all resources on last close.
> I think this change will fix oops in empress_querycap.
> 
> http://kerneloops.org/guilty.php?guilty=empress_querycap&version=2.6.25-release&start=1671168&end=1703935&class=oops
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: video4linux-list@redhat.com
> ---
> 
> Compile tested only. Please test on real hardware.

Thanks.

The patch looks sane to my eyes. I'll apply at the tree, in order to allow more
people to test it.


Cheers,
Mauro
