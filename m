Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbXBVVuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbXBVVuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXBVVuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:50:50 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:45364 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751903AbXBVVut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:50:49 -0500
Subject: Re: [Patch 2/2] cciss: add shutdown support (replaces reboot
	notifier)
From: James Bottomley <James.Bottomley@SteelEye.com>
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, gregkh@novell.com, hch@infradead.org
In-Reply-To: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
References: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 15:49:38 -0600
Message-Id: <1172180978.3378.35.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 15:38 -0600, Mike Miller (OS Dev) wrote:
>         .remove = __devexit_p(cciss_remove_one),
>         .id_table = cciss_pci_device_id,        /* id_table */
> +       .shutdown = cciss_remove_one,

You need a __devexit_p() wrapper for this one too.

James


