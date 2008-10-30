Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbYJ3Sbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbYJ3Sbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYJ3Sbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:31:33 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:37222 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012AbYJ3Sbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:31:32 -0400
Date: Thu, 30 Oct 2008 18:58:11 +0100
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc2 lost IDE disk on old laptop fixed
Message-ID: <20081030175810.GA2834@erig.dyndns.org>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org> <20081030135017.GA8325@erig.dyndns.org> <9ea470500810300733u34dab7d2rd69a8d806b85ac65@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ea470500810300733u34dab7d2rd69a8d806b85ac65@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 03:33:38PM +0100, Borislav Petkov wrote:
> Hi,
> 
> On Thu, Oct 30, 2008 at 2:50 PM, Wolfgang Erig <Wolfgang.Erig@gmx.de> wrote:
> > Hi,
> >
> > the kernel 2.6.28-rc2 does not boot on my old laptop.
> > Panic ... cannot access (301) ... aka /dev/hda1
> > The previously used version 2.6.27-rc8 runs fine.
> >
> > During 'make oldconfig' I saw questions about IDE (or ATA)
> > but I see no obvious problem with my .config
> >
> > Wolfgang
> >
> >
> > $ lspci
> > 00:00.0 Host bridge: Intel Corporation 430TX - 82439TX MTXC (rev 01)
> > 00:01.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 01)
> > 00:01.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
> 
> Have you tried compiling your kernel with CONFIG_BLK_DEV_PIIX enabled and
> CONFIG_IDE_GENERIC disabled?

tried it with success.
Thanks Borislav and all for keeping this old laptop running with the
latest greatest kernel.

Wolfgang
