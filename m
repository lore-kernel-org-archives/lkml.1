Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZBQO3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZBQO3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZBQO2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:28:54 -0500
Received: from h155.mvista.com ([63.81.120.155]:25041 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751856AbZBQO2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:28:53 -0500
Message-ID: <499AC9BA.1080906@ru.mvista.com>
Date: Tue, 17 Feb 2009 17:29:14 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] ide: add ->dma_expiry method and remove ->dma_exec_cmd
 one
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain> <200902111730.39460.bzolnier@gmail.com> <49930B2D.8090503@ru.mvista.com> <200902171516.34091.bzolnier@gmail.com>
In-Reply-To: <200902171516.34091.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>Hello.

>>Bartlomiej Zolnierkiewicz wrote:

>>>>Bartlomiej Zolnierkiewicz wrote:

>>>>>* Rename dma_timer_expiry() to ide_dma_sff_expiry() and export it.

>>>>>* Add ->dma_expiry method

>>>>   This name doesn't seem to make much sense. Why not leave it dma_timer_expiry?

>>>Well, the name matches with hwif->expiry one + the downside of leaving it at
>>>dma_timer_expiry is a need to reformat all struct ide_dma_ops instances...

> On the 2nd look it doesn't seem to be a problem (I must have been looking at
> some odd case previously) -- I'll fix it up later.

    I vote for timer_expiry().

MBR, Sergei
