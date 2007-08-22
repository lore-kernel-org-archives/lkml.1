Return-Path: <linux-kernel-owner+w=401wt.eu-S1765740AbXHVRYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765740AbXHVRYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762987AbXHVRYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:24:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:34306 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759745AbXHVRYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:24:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=saRIN/CXJwc/V39qGQTyDOPvvZfx7/wV2ade87Wdphajp1qjpoo4Q1FaJdvgy22GEMCcguhBD06SpoLZBF7+w6jJSByKn+meymOwgqiJjirk4+5ogMyyqzR+GS1yKw4HXk93D3SFtRUoI6v41STviLOrFfWyqtH36uPnc3GUW2c=
Message-ID: <64bb37e0708221024p5184aa65x5d36c7c049049124@mail.gmail.com>
Date: Wed, 22 Aug 2007 19:24:39 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc3-mm1
Cc: "Kuan Luo" <kluo@nvidia.com>, "Peer Chen" <pchen@nvidia.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
[snip]
> -ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
> -ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
[snip]
>  Merged into mainline or a subsystem tree

That patch is no longer in 2.6.23-rc3-mm1, my bootlog says:
[    0.000000] Unknown boot option `sata_nv.swncq=1': ignoring

I could not find this patch in any git trees I looked and its removal
mail from mm-commit said:
"This patch was dropped because Changes in Jeff's tree destroyed it."


I only found out about the swncq=1 command line option yesterday and
so tested it only one day.
But I did not have any trouble with it, even as my drive was made by Maxtor.

The chipset:
00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
00:05.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)

The drive:
Device Model:     MAXTOR STM3320820AS
Serial Number:    5QF2E698
Firmware Version: 3.AAE

As it worked for me, I hope that patch will be picked up by someone. :)

Torsten
