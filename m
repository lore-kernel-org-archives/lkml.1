Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314Ab0ARRry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab0ARRry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327Ab0ARRrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:47:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35960 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752343Ab0ARRrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:47:51 -0500
Date: Mon, 18 Jan 2010 17:50:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/64] pata_amd: remove bogus code from timing_setup()
Message-ID: <20100118175037.23727d64@lxorguk.ukuu.org.uk>
In-Reply-To: <20100118171420.14623.85263.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118171420.14623.85263.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 18:14:20 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_amd: remove bogus code from timing_setup()
> 
> DMA modes don't have 8-bit timings.

If you are in a DMA based mode then you have 8bit timings for writes to
the non data registers. You can get an 8bit timed access to the other
drive even in DMA mode. 

