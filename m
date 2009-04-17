Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbZDQJub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbZDQJub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758002AbZDQJuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 05:50:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43141 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754054AbZDQJuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:50:15 -0400
Date: Fri, 17 Apr 2009 10:50:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] AHCI updates: Marvell AHCI PATA works; pata_marvell
 fate?
Message-ID: <20090417105031.607a771e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090417023949.GA14469@havoc.gtf.org>
References: <20090417023949.GA14469@havoc.gtf.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Marvell PATA on 6121 and similar chips should also work, but that hasn't
> yet been tested.  Here's the full list of what still needs testing:
> 
> - master + slave devices
> - ATAPI
> - 6121 (6123? others?)

LBA48


> 
> Also, there is the open question of how to deal with pata_marvell
> co-existence

I think for the moment make PATA support by AHCI a config option and as
soon as we trust it we can get rid of the option and of pata_marvell.

Alan
