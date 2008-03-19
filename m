Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYCSTri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYCSTri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbYCSTcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:32:23 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:51274 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbYCSTcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:32:08 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Wed, 19 Mar 2008 11:08:18 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803190853.10030.volker.armin.hemmann@tu-clausthal.de> <47E0D5C8.9070005@gmail.com>
In-Reply-To: <47E0D5C8.9070005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803191108.18577.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 19. März 2008, Tejun Heo wrote:
> x UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200
>
> > irq 315
> > [   38.125479] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port
> > 0xf9dfc280 irq 315
> > [   38.597035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [   38.597732] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max
> > UDMA/133 [   38.597775] ata1.00: 312581808 sectors, multi 16: LBA48
> > [   38.598405] ata1.00: configured for UDMA/133
> > [   39.069342] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [   39.084225] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
> > [   39.084264] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth
> > 0/32) [   39.086268] ata2.00: configured for UDMA/133
>
> So, just to confirm.  With the updated patch, you don't see any problem,
> right?

Correct. With the updated patch I don't see problems in 'non-raid' mode. AHCI 
mode still has problems without nosmi. But that is an entirely different 
problem, right?

Glück Auf,
Volker
