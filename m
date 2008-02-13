Return-Path: <linux-kernel-owner+w=401wt.eu-S1764667AbYBMARa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764667AbYBMARa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763424AbYBMARP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:17:15 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59895 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763342AbYBMARN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:17:13 -0500
Subject: Re: [PATCH] 2.6.25-rc1-git2: GDT SCSI: change drivers/scsi/gdth.c
	into using pci_get device
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Sergio Luis <sergio@larces.uece.br>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Achim Leubner <achim_leubner@adaptec.com>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47B23033.1080100@larces.uece.br>
References: <47B1ADCE.40202@larces.uece.br>
	 <1202833354.3137.19.camel@localhost.localdomain>
	 <47B1CF45.5070407@panasas.com>  <47B23033.1080100@larces.uece.br>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 18:17:03 -0600
Message-Id: <1202861823.3137.170.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 20:48 -0300, Sergio Luis wrote:
> reposting an updated version of it. Please check if it's ok.

Looks fine, thanks!  You added an extra space at the end of 

while ((pdev = pci_get_device(vendor, device, pdev)) 

Which I fixed.  Unfortunately checkpatch isn't very helpful for this
driver since it uses spaces not tabs everywhere, which checkpatch really
hates.

James


