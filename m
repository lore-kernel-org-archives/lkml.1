Return-Path: <linux-kernel-owner+w=401wt.eu-S1762252AbXGROc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762252AbXGROc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbXGROcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:32:48 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37848 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXGROcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:32:47 -0400
Date: Wed, 18 Jul 2007 16:32:46 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
cc: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
In-Reply-To: <20070716162206.392129000@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.64.0707181632200.5385@fbirervta.pbzchgretzou.qr>
References: <20070716161539.075822000@pademelon.sonytel.be>
 <20070716162206.392129000@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 16 2007 18:15, Geert Uytterhoeven wrote:
>
>Add a Disk Storage Driver for the PS3:
>  - Implemented as a block device driver with a dynamic major
>  - Disk names (and partitions) are of the format ps3d%c(%u)
>  - Uses software scatter-gather with a 64 KiB bounce buffer as the hypervisor
>    doesn't support scatter-gather

I wonder what virtualization has to do with a block device driver?


	Jan
-- 
