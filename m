Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798Ab0ARSAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab0ARSAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490Ab0ARSAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:00:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58324 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752347Ab0ARSAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:00:51 -0500
Date: Mon, 18 Jan 2010 18:03:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/64] pata_via: store UDMA masks in via_isa_bridges
 table
Message-ID: <20100118180337.64f4f45b@lxorguk.ukuu.org.uk>
In-Reply-To: <20100118171712.14623.9408.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118171712.14623.9408.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	switch (udma_type) {
> +	case ATA_UDMA4:
> +		UT = T / 2; break;
> +	case ATA_UDMA5:
> +		UT = T / 3; break;
> +	case ATA_UDMA6:
> +		UT = T / 4; break;
> +	}

UT = T (udma_type - ATA_UDMA3) ?



Looks good
