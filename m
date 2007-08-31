Return-Path: <linux-kernel-owner+w=401wt.eu-S1762028AbXHaUOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762028AbXHaUOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbXHaUOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:14:38 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:61953 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbXHaUOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:14:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r+0FkQZfCQgCVYDAVk6ZcEsXUCZu6M54Z7qbu2+LrioHp6yY06NX0POU9LdTnPMZAsgigCeQN7fPdzmi0esV4M3jfkf5svgRke+lULPPiNTZFDjeoiRCDU1diJBMJRBnlHTMYlBpmzvmkPoXss8WPPekyrVEWj9i3Yuj80sTnjA=
Message-ID: <8b67d60708311314p39c7be30v630e97189d656abf@mail.gmail.com>
Date: Fri, 31 Aug 2007 21:14:36 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH] Patch pvr2 driver to allow development of maple bus driver
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       "Paul Mundt" <lethal@linux-sh.org>
In-Reply-To: <8bd0f97a0708311312n78f1c163o20aa17214bfe3702@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60708311300k3ea67eadod531752cca253bbc@mail.gmail.com>
	 <8b67d60708311306v344e8f00w36dc244fc39df39f@mail.gmail.com>
	 <8bd0f97a0708311312n78f1c163o20aa17214bfe3702@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/2007, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On 8/31/07, Adrian McMenamin <lkmladrian@gmail.com> wrote:
> > This patch makes the PVR2 VBLANK interrupt on the SEGA Dreamcast
> > shareable - a small but necessary change to enable ongoing efforts to
> > develop a driver for the maple bus on the Dreamcast. (Maple is Sega's
> > proprietary serial interface for the Dreamcast and can be set to
> > synchronise dma transfers to the VBLANK).
> >
> > This has no impact on the performance of the PVR2.
>
> sharable implies the interrupt handler checks to see if it actually
> caused the interrupt ... which it doesnt at the moment ... presumably,
> you're making it shared because another device will be using that
> interrupt as well ... so when that other device gets an interrupt, how
> do you know it's for that device and not PVR2 ?


If the interrupt occurs then it will be for both of them. The hardware
cannot be removed and the maple bus driver is set for hardware sync.

The question seems redundant to me.
