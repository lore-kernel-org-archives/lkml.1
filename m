Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbZKYRXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbZKYRXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759320AbZKYRXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:23:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53894 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759286AbZKYRXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:23:47 -0500
Date: Wed, 25 Nov 2009 17:25:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/86] pata_efar: MWDMA0 is unsupported
Message-ID: <20091125172552.6817e3da@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125170415.5446.15073.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125170415.5446.15073.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 18:04:15 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_efar: MWDMA0 is unsupported
> 
> MWDMA0 timings cannot be met with the PIIX based controller
> programming interface.

The efar documentation makes no reference to not being capable of MWDMA0,
so where does this come from ? No MWDMA0 is an Intel erratum it appears.
