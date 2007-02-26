Return-Path: <linux-kernel-owner+w=401wt.eu-S1030217AbXBZNQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030217AbXBZNQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030221AbXBZNQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:16:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53841 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030217AbXBZNQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:16:50 -0500
Date: Mon, 26 Feb 2007 14:20:41 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?w5h5dmluZA==?= Repvik <repvik@kynisk.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.20-rc1-git1] siimage SIL 3512 support
Message-ID: <20070226142041.4ce029ab@lxorguk.ukuu.org.uk>
In-Reply-To: <45E25BDC.2060505@kynisk.com>
References: <45E25BDC.2060505@kynisk.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007 05:02:36 +0100
Øyvind Repvik <repvik@kynisk.com> wrote:

> Patch to enable SIL 3512 S-ATA controller, used in eg. QNAP TS-101 and 
> TS-201 devices.

NAK

The 3512 is not quite the same as the 3112. It is supported by
drivers/ata/sata_sil.c for the new SATA layer. If you want to use the old
IDE layer and you know there will be no hotplug etc then you'll also need
to port the other 3114, 3512 differences over including the FIS errata
workarounds from the libata SATA driver into the legacy one.

Alan



