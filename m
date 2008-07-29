Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbYG2PpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbYG2PpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYG2PoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:44:10 -0400
Received: from nebensachen.de ([195.34.83.29]:53382 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbYG2PoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:44:09 -0400
X-Hashcash: 1:20:080729:bzolnier@gmail.com::gclcWEsECjV3SdU6:00000000000000000000000000000000000000000003Teu
X-Hashcash: 1:20:080729:linux-ide@vger.kernel.org::3T+UMRNGZMx8r1G3:00000000000000000000000000000000000013Wf
X-Hashcash: 1:20:080729:linux-kernel@vger.kernel.org::7keH4N60I/yPRiPl:000000000000000000000000000000000753b
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ide: /proc/ide/hd*/settings rework
References: <20080727185602.4660.66530.sendpatchset@localhost.localdomain>
Date: Tue, 29 Jul 2008 17:43:55 +0200
Message-ID: <87od4gn1ac.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> Hi,
>
> I finally dusted off /proc/ide/hd*/settings rework (this has been laying
> on my hdd and waiting for the better days for at least 1.5 year, draft
> version even longer like ~3 years... sigh).
>
> The main motivation for doing it is that with infrastructure for private
> IDE subsystem requests from Elias Oltmanns (which was merged recently)
> and this patchset it should be possible (by using private requests for
> device settings) to make IDE locking code a lot saner and get rid of
> of ide_spin_wait_hwgroup()-ugliness completely.
>
> Elias if you would like to take care of it please go ahead [ from a quick
> look it seems this would mostly require adding new request type, pointing
> rq->special to setting's ->get or ->set method and putting setting's type
> (read/write -> 1 bit) + argument (int) somewhere inside request but you
> probably know better ].

Yes, I'll have a go at it. I haven't quite figured out yet whether I can
(or should, for that matter) get rid of drive->special and convert the
rest accordingly.

Anyway, I probably won't get it done before next week.

Regards,

Elias
