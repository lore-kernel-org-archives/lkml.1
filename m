Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbYG1QXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbYG1QXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYG1QX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:23:28 -0400
Received: from 85-10-209-111.clients.your-server.de ([85.10.209.111]:54168
	"EHLO mail.road.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYG1QX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:23:27 -0400
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix misalignment in pxamci
Date: Mon, 28 Jul 2008 18:23:24 +0200
User-Agent: KMail/1.9.9
Cc: "pHilipp Zabel" <philipp.zabel@gmail.com>,
       "Marek Vasut" <marek.vasut@gmail.com>, drzeus-mmc@drzeus.cx
References: <200807050219.52218.marek.vasut@gmail.com> <74d0deb30807050121n38c44dfaoa843fe8a0b581d01@mail.gmail.com>
In-Reply-To: <74d0deb30807050121n38c44dfaoa843fe8a0b581d01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281823.25302.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5. July 2008, pHilipp Zabel wrote:
> On Sat, Jul 5, 2008 at 2:19 AM, Marek Vasut <marek.vasut@gmail.com> wrote:
> > Hi,
> > Philipp Zabel finally made the pxamci issue clear. It turned out, that
> > pxamci needs the DMA destination address to be aligned to 8 bytes. In
> > some cases it happened, that the address was aligned to 4 bytes causing
> > controller to incorrectly transfer data (and resulting into error like
> > "mmc0: unrecognised SCR structure version 1"). The following patch allows
> > to debug this issue and moreover fixes it by moving one 4 byte entry of
> > mmc_card structure, aligning the DMA destination back to 8 bytes.
> >
> > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
>
> We can enable byte aligned transfers on the DMA controller. This is
> what I came up with yesterday:
> (sorry for wrapped lines - the proper patch should probably be a
> combination of both
> warning/DALGN handling and and moving something in mmc_card around).
>
Hi Philipp,
this driver is not only for pxa27x but for pxa25x as well and pxa25x can't 
handle unaligned DMA.
Shouldn't Marek Vasut's patch be included for the PXA25x case?

regards,
Uli


-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit
