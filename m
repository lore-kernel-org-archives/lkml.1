Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbXC0LCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbXC0LCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 07:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXC0LCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 07:02:00 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:25806 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbXC0LB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 07:01:59 -0400
Date: Tue, 27 Mar 2007 13:03:51 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: gregkh@suse.de
Cc: Adrian Bunk <bunk@stusta.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove the broken PCI_MULTITHREAD_PROBE option
Message-ID: <20070327130351.51aff00e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070327010251.GX16477@stusta.de>
References: <20070327010251.GX16477@stusta.de>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 03:02:51 +0200,
Adrian Bunk <bunk@stusta.de> wrote:

> This patch removes the PCI_MULTITHREAD_PROBE option that had already 
> been marked as broken.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
>  Documentation/pci.txt    |    4 ---
>  drivers/base/dd.c        |   41 ++-------------------------------------
>  drivers/pci/Kconfig      |   25 -----------------------
>  drivers/pci/pci-driver.c |   15 --------------
>  include/linux/device.h   |    1 
>  5 files changed, 3 insertions(+), 83 deletions(-)

Greg, what about driver-core-per-subsystem-multithreaded-probing.patch?
PCI_MULTITHREAD_PROBE shoudn't be broken with that, only in mainline?
