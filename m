Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYDHJRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYDHJRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYDHJRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:17:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42411 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYDHJRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:17:16 -0400
Date: Tue, 8 Apr 2008 10:16:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: eric miao <eric.y.miao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel email list 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>, Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH 4/4] pxafb: preliminary smart panel interface support
Message-ID: <20080408091635.GA23165@flint.arm.linux.org.uk>
References: <f17812d70804072107k77c2642ah23c8f2ce9535159f@mail.gmail.com> <20080408012359.d0a7d0c8.akpm@linux-foundation.org> <f17812d70804080134kaeefa59tf4dc583afcc384e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70804080134kaeefa59tf4dc583afcc384e7@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 04:34:05PM +0800, eric miao wrote:
> >From 3b14d02739b98ed8be3904914dd8b9d4a39fff25 Mon Sep 17 00:00:00 2001
> From: Eric Miao <eric.miao@marvell.com>
> Date: Mon, 7 Apr 2008 15:57:56 +0800
> Subject: [PATCH] pxafb: preliminary smart panel interface support
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Acked-by: Eric Miao <eric.miao@marvell.com>
> ---
> Andrew: please see if this modified version applies: FB_PXA_SMARTPANEL
> defaults to "n" and removed the cast to void *, thanks    - eric

No need to add an explicit "default n" - defaulting to 'n' is the
default unless otherwise set.
