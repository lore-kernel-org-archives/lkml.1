Return-Path: <linux-kernel-owner+w=401wt.eu-S1762646AbXEPMhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762646AbXEPMhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762657AbXEPMg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:36:58 -0400
Received: from ipmail03.adl2.internode.on.net ([203.16.214.135]:8625 "EHLO
	ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762637AbXEPMg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:36:57 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2007 08:36:56 EDT
X-IronPort-AV: E=Sophos;i="4.14,543,1170595800"; 
   d="scan'208";a="90067233"
Message-ID: <464AF9BD.6040107@iinet.net.au>
Date: Wed, 16 May 2007 22:31:57 +1000
From: Ben Nizette <ben.nizette@iinet.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Make prepare_namespace() wait for devices (v2)
References: <464853D9.70904@drzeus.cx>	<20070514123436.GB4095@ftp.linux.org.uk>	<46486A7F.8050705@drzeus.cx>	<20070514160403.6414f149@dhcp-252-105.norway.atmel.com>	<46487DAE.5000206@drzeus.cx> <20070516111531.03164a36@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070516111531.03164a36@dhcp-252-105.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:
> On Mon, 14 May 2007 17:18:06 +0200
> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> 
>> New suggestion.
> 
> Works wonderfully here:
> 
> Waiting for root device /dev/mmcblk0p1...
> <inserts card>
> mmcblk0: mmc0:a95c SD128 123008KiB
>  mmcblk0: p1
> VFS: Mounted root (ext2 filesystem).
> 
> Of course, it also fixes the case where the card _is_ inserted at
> bootup :-)

Seconded.  Love your work Pierre :)

Tested across 4 different brands of SD/MMC/RS-MMC card and 2 different 
configurations (both AVR32 arch) just for the hells of it.  All plays nice.

Thanks,
--Ben.
