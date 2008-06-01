Return-Path: <linux-kernel-owner+w=401wt.eu-S1752510AbYFATAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbYFATAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 15:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYFATAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 15:00:13 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33441 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYFATAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 15:00:12 -0400
Date: Sun, 1 Jun 2008 21:00:11 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Gene Heskett <gene.heskett@gmail.com>
cc: Phillip Susi <psusi@cfl.rr.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: floppy question of the hour
In-Reply-To: <200805271826.18320.gene.heskett@gmail.com>
Message-ID: <alpine.LNX.1.10.0806012053440.4055@fbirervta.pbzchgretzou.qr>
References: <200805232114.20937.gene.heskett@gmail.com> <200805240852.58268.gene.heskett@gmail.com> <483C81DE.8060002@cfl.rr.com> <200805271826.18320.gene.heskett@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-05-28 00:26, Gene Heskett wrote:
>On Tuesday 27 May 2008, Phillip Susi wrote:
>>Gene Heskett wrote:
>
>Also, does anyone know how long after a floppy is inserted before it is 
>recognized?  From observation today, it appears to be something in the 5 minute 
>territory before a getfdprm returns data instead of "/dev/fd0: no such device".

I have a SONY USB floppy drive which used to get read within 2s
after inserting a new floppy. Which means it somehow signalled
the host, probably through an USB command.

Just as I tried again now (with 2.6.23.17), this does not happen
anymore so I suspect udev or the kernel changed in some way.
