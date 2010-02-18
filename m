Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab0BRVqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 16:46:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53099 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754186Ab0BRVqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 16:46:21 -0500
Date: Thu, 18 Feb 2010 21:45:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] pata_oldpiix: add locking for parallel scanning
Message-ID: <20100218214531.60a08f00@lxorguk.ukuu.org.uk>
In-Reply-To: <20100218185928.16594.4054.sendpatchset@localhost>
References: <20100218185914.16594.61415.sendpatchset@localhost>
	<20100218185928.16594.4054.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010 19:59:28 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_oldpiix: add locking for parallel scanning
> 
> Add an extra locking for parallel scanning.
> 
> This is similar change as commit 60c3be3 for ata_piix host driver
> and while pata_oldpiix doesn't enable parallel scan yet the race
> could probably also be triggered by requesting re-scanning of both
> ports at the same time using SCSI sysfs interface.
> 
> Fix documentation while at it.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>
