Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYEOHmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYEOHmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbYEOHlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:41:35 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:56206 "EHLO
	toronto.xi-lite.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758075AbYEOHld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:41:33 -0400
Message-ID: <482BE929.7090009@parrot.com>
Date: Thu, 15 May 2008 09:41:29 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>
Subject: Re: ata_piix 2.6.25 sata failure
References: <482949CB.7000208@parrot.com>
In-Reply-To: <482949CB.7000208@parrot.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2008 07:42:10.0339 (UTC) FILETIME=[2ECCEF30:01C8B65F]
X-AV-Checked: No Virus Found
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Matthieu CASTET wrote:
> Hi,
> 
> the 2.6.25 from debian fail to make work the second port. I got a "SATA 
> link down (SStatus 61 Scontrol 30)" for ata2. ata1 got "SATA link up 3.0 
> Gbps (SStatus 13 SControl 30)"
> The 2.6.24 works [1]. But some previous kernel (IRRC 2.6.18) had the 
> same problem, ie ata2 doesn't work.
> 
I saw you post a patch for macbook for correcting a bug with ata_ppiix.
But it doesn't seem the same problem. I don't get 0 but others values.

May be a problem occurs when merging the master and slave status register ?


Any idea how to debug this.

For information this happen on a HP Compaq dc7700p, and there no way on 
the bios to change the controller to ahci mode


Thanks

Matthieu

