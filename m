Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbXHSKrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbXHSKrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 06:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbXHSKqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 06:46:53 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:4971 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbXHSKqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 06:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UU2Q2cq+uQHCmMac20wH7o/m220FRmYCFJh9ZCNvICCSsnsdaCbSB1M/UvNNCbzOr2VVpLTSYEiu1QDPeNSKpL17KtX8G/KKfbtlTHbzM/FYR1loG2iGShACsFW9cOWbJuRGGALeHeG+2PtYfb6pLKGeMtuf5NvnKZu2+En1ZSI=
Message-ID: <46C81F4C.2030407@gmail.com>
Date: Sun, 19 Aug 2007 19:45:32 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Maciek Rutecki <maciej.rutecki@gmail.com>
CC: Linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, rjw@sisk.pl
Subject: Re: SATA error while resume
References: <46C80999.1060700@gmail.com>
In-Reply-To: <46C80999.1060700@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciek Rutecki wrote:
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata1.00: irq_stat 0x40000001
> ata1.00: cmd 25/00:00:10:0b:f3/00:04:05:00:00/e0 tag 0 cdb 0x0 data
> 524288 in
>          res 51/40:a4:6c:0b:f3/00:03:05:00:00/e0 Emask 0x9 (media error)
> ata1.00: configured for UDMA/100
> 
> Then system continue booting without resume.
> 
> I use smartctl and check disk 2 times and run fsck/mkswap -c and I have
> no erros:
> 
> =================
>   5 Reallocated_Sector_Ct   0x0033   100   100   024    Pre-fail  Always
>       -       8589934592000
> 196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always
>       -       444268544

It very much looks like the disk is dying.  Dunno why it doesn't show up
during SMART testing but you better back up and contact the hardware vendor.

-- 
tejun
