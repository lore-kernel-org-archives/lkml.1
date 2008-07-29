Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYG2LJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYG2LJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 07:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbYG2LJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 07:09:31 -0400
Received: from server.drzeus.cx ([85.8.24.28]:47809 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755862AbYG2LJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:09:30 -0400
Date: Tue, 29 Jul 2008 13:09:17 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "pHilipp Zabel" <philipp.zabel@gmail.com>
Cc: "Uli Luckas" <u.luckas@road.de>, LKML <linux-kernel@vger.kernel.org>,
       "Marek Vasut" <marek.vasut@gmail.com>
Subject: Re: [PATCH] fix misalignment in pxamci
Message-ID: <20080729130917.116df5bc@mjolnir.drzeus.cx>
In-Reply-To: <74d0deb30807282330y142cedd2ld0ecf33cc459a75a@mail.gmail.com>
References: <200807050219.52218.marek.vasut@gmail.com>
	<74d0deb30807050121n38c44dfaoa843fe8a0b581d01@mail.gmail.com>
	<200807281823.25302.u.luckas@road.de>
	<74d0deb30807282330y142cedd2ld0ecf33cc459a75a@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 08:30:09 +0200
"pHilipp Zabel" <philipp.zabel@gmail.com> wrote:

> 
> Argh, DALGN shouldn't be defined in pxa-regs.h. We really need an
> aligned SCR target then. Pierre, is there any way we can have the MMC
> core align DMA targets for pxa25x?
> 

No, not really. So if you can't work around the hardware limitations,
add a bounce buffer or fail the requests that cannot be handled (or
both, if you have a bounce buffer that's smaller than the maximum
request size).


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
