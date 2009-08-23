Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbZHWMHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbZHWMHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbZHWMHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:07:45 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:54120 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933522AbZHWMHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 08:07:40 -0400
From: Frans Pop <elendil@planet.nl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.31-rc6: ACPI handle has no context apparenty from libata during suspend to RAM
Date: Sun, 23 Aug 2009 14:07:37 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200908231424.07900.arvidjaar@mail.ru>
In-reply-To: <200908231424.07900.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908231407.38543.elendil@planet.nl>
X-OriginalArrivalTime: 23 Aug 2009 12:07:39.0008 (UTC) FILETIME=[4F1CB000:01CA23EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> sd 0:0:0:0: [sda] Stopping disk
> ACPI handle has no context!
> sdhci-pci 0000:03:01.1: PME# disabled
> sdhci-pci 0000:03:01.1: PCI INT B disabled
> ACPI handle has no context!
> ata5: port disabled. ignoring.

I have a few of those too. I've been intending to try to investigate them, 
but haven't gotten around to it yet. One problem is that there is no 
context information in the error message itself (what 
driver/function/whatever).

Are they new for you in .31 or have they always been there? I suspect the 
latter, in which case I wouldn't worry about them too much. I at least 
have never noticed any actual negative impact from them.

Cheers,
FJP
