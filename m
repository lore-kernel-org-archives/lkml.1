Return-Path: <linux-kernel-owner+w=401wt.eu-S934815AbZKYRuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934815AbZKYRuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932982AbZKYRux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:50:53 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56871 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932858AbZKYRuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:50:52 -0500
Date: Wed, 25 Nov 2009 17:52:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 82/86] pata_via: clear UDMA transfer mode bit for PIO
 and MWDMA
Message-ID: <20091125175257.796afeb3@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125171218.5446.41962.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125171218.5446.41962.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	/* Set UDMA unless device is not UDMA capable */
> -	if (udma_type && t.udma) {
> -		u8 cable80_status;
> +	if (udma_type) {
> +		u8 udma_etc;

This seems odd the original test is that we are a udma controller and
have a udma timing specified. Otherwise there is no point doing any work.

The rest seems to be gratuitious register renaming and makes the patches
hard to review. Please split this sort of stuff up.

