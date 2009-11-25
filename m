Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbZKYRjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbZKYRjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759445AbZKYRjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:39:02 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53906 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759442AbZKYRjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:39:00 -0500
Date: Wed, 25 Nov 2009 17:41:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 51/86] libata: remove no longer needed pata_qdi driver
Message-ID: <20091125174105.33761baa@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125170823.5446.16710.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125170823.5446.16710.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 18:08:23 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] libata: remove no longer needed pata_qdi driver
> 
> QDI65x0 controllers are fully supported by pata_legacy driver
> so remove no longer needed pata_qdi driver.
> 
> Leave PATA_QDI config option for compatibility reasons and teach
> pata_legacy to preserve the old behavior of pata_qdi driver. 

Just delete it nobody will care. I sent Jeff patches to delete it a
couple of times before but they got dropped
