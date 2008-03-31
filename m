Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYCaVlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYCaVlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbYCaVlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:41:40 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4402 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbYCaVlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:41:40 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and ->ata_*put_data methods
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
Content-Disposition: inline
From: Roman Zippel <zippel@linux-m68k.org>
Date: Mon, 31 Mar 2008 22:41:06 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803312341.08271.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 31. March 2008, Alan Cox wrote:

> > Yes, the data on the disk is stored byte-swapped.
> > So it's only the drive ID and packet commands that should be swapped.
>
> If you are storing the data on disk byte swapped then reverse the logic
> in the driver so you don't need hacks for un-swapping commands and write
> a bytesewap device mapper layer in the right place. Then you can even
> move disks around.

That would require an additional data copy and a double byteswap on machines 
which are not that fast in first place...

bye, Roman
