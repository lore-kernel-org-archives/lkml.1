Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYAIClc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYAIClc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYAIClY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:41:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:52122 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYAIClW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:41:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=taZvbLJ6VwwVcc1R1d4E7Hnabk0z/7dNgyoFCSEqGNuI3FBou8d7VjwaNmUPg8RVaX6fqrD9vlfEIJOhp5Ph8nRgPd2F4P3WBko7DSd/QKC90cMZUaRZT4ztQXdG3sUx/yJDomjWh8ELkID8OqrOUYeqYMQx7BQtHbxubOyj2vM=
Message-ID: <4784344C.5060208@gmail.com>
Date: Wed, 09 Jan 2008 11:41:16 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata and starting/stopping ATAPI floppy devices
References: <200801051647.58866.linux@rainbow-software.org>
In-Reply-To: <200801051647.58866.linux@rainbow-software.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary wrote:
> Hello,
> I switched to libata drivers for my onboard PATA controller (PIIX4) recently. 
> Everything works fine except that kernel tries to start not only my hard 
> drive (sda) but also LS-120 floppy drive (sdb) which does not like it:
> 
> sd 0:0:0:0: [sda] Starting disk
> ata1.00: configured for UDMA/33
> sd 0:0:0:0: [sda] 58633344 512-byte hardware sectors (30020 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
> DPO or FUA
> sd 1:0:1:0: [sdb] Starting disk
> ata2.00: configured for UDMA/33
> ata2.01: configured for PIO2
> sd 1:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
> sd 1:0:1:0: [sdb] Sense Key : 0x2 [current]
> sd 1:0:1:0: [sdb] ASC=0x3a ASCQ=0x0
> 
> 
> The question is: is it correct? Or a patch like this should be applied?

Yeah, looks good to me.  Please reformat the message w/ S-O-B.

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
