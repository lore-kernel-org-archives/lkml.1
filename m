Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbZDTIgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbZDTIgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZDTIft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:35:49 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:5822 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZDTIfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jBQw8zb1ROkqEEveL5LwaDhi2GU4En2oftubIcBWExIDuhrylMmKXHUZ1XYunqEas5
         CekSoa7b1dVv6Jdj3gxlIdyuJTgCJkdtyDqPQRpKy80LglkKr0ZpbTqCaibA5m+NcYWd
         kWUeMTDyBcl7+WT7sMdMM+6v9ZvjD/7lxn4gU=
Message-ID: <49EC33DB.5060808@gmail.com>
Date: Mon, 20 Apr 2009 17:35:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: Linux IDE <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux SCSI <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] ide: Stop disks on reboot for laptop which cuts power
References: <20090418124415.1dc82273@neptune.home>	<20090418124558.0426f74c@neptune.home>	<49EC299D.5020102@gmail.com> <20090420102826.5184f3fe@pluto.restena.lu>
In-Reply-To: <20090420102826.5184f3fe@pluto.restena.lu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Bruno Prémont wrote:
> Possibly it depends very much how the power is connected,
> e.g. desktop boxes with ATX power-supply probably never tell the
> power-supply to cut the power but laptop may behave differently with
> regard to their built-in DC-DC converters (disks connected to
> mainboard versus disks directly connected to power supply).

I've seen several desktop motherboards which fully power cycle disks
on reboot.  Dunno where the difference comes from tho.  IIRC, some
intel boards seem to do things that way.

> What I was also wondering whether the list of machines to which to
> apply the quirk should be moved to a common location so it exists
> only once for ide and scsi/ata instead of once on each side.  Having
> the list exactly once avoids the risk for content to drift between
> ide and scsi/ata.

Hmmm....

Thanks.

-- 
tejun
