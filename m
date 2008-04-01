Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYDAGrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYDAGrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 02:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYDAGrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 02:47:39 -0400
Received: from mail.rz.uni-duesseldorf.de ([134.99.128.30]:33633 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbYDAGri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 02:47:38 -0400
X-Greylist: delayed 12399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2008 02:47:37 EDT
Date: Tue, 01 Apr 2008 05:20:56 +0200 (CEST)
From: Michael Schmitz <schmitz@smaragd.biophys.uni-duesseldorf.de>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and
 ->ata_*put_data methods
In-reply-to: <20080331224318.4768c050@core>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
Message-id: <Pine.LNX.4.44.0804010512010.22211-100000@smaragd.biophys.uni-duesseldorf.de>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > That would require an additional data copy and a double byteswap on machines
> > which are not that fast in first place...
>
> So use the blitter ;)
>
> At this point the future is not Commode Amiga or Atari TT and we risk
> mess in core code for obscure platforms ?

The Amiga isn't affected by this. Only Falcon and Q40 (Atari) are.

Sorry for the mess in core code - ist there any other way for only driveid
and packet data getting swapped? And can we actually use the device mapper
to byte-swap the root partition?

	Michael


