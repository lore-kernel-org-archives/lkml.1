Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbXBESg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbXBESg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933327AbXBESg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:36:26 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:43158 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933325AbXBESgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:36:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Ngj/mm8vCIh8ILRQ7z52l8+8XcKjnlWQQdhKOPSrizqzIT0G/RgLrkHvSItGAULvLXYy6A2dyQYuDhwuTrmwlU9r4vFcjheECDRKw+kmO9dY5sGBPNHSC5aRj/HjXI8nxkSkyVZeHdg57oe1KLO3hG3z/ph/x6ErP3TEE9sPKeU=
Message-ID: <45C77921.4020808@gmail.com>
Date: Tue, 06 Feb 2007 03:36:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Allen Martin <AMartin@nvidia.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Nvidia cable detection problems (was [PATCH] amd74xx: don't configure
 udma mode higher than BIOS did)
References: <20070205075836.GG1625@htj.dyndns.org>	<20070205112410.5a3c3182@localhost.localdomain>	<45C72012.7050605@gmail.com>	<20070205132247.6f611e3c@localhost.localdomain>	<45C73A3E.6080700@gmail.com>	<20070205143439.6962c076@localhost.localdomain>	<45C7444F.4070500@gmail.com>	<58cb370e0702050709w1b7682dr5dff9e7ce69465a@mail.gmail.com>	<DBFABB80F7FD3143A911F9E6CFD477B01EC0DD7D@hqemmail02.nvidia.com> <20070205181224.3319d6c3@localhost.localdomain>
In-Reply-To: <20070205181224.3319d6c3@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
>> The *real* solution is to use the BIOS ACPI _GTM _STM methods for this.
>> Then you can remove all chipset specific knowledge from the IDE driver.
>> This is what the MS driver does on Windows, so you know it's received a
>> lot of testing from NVIDIA and board vendors.
> 
> Well we can certainly do some of that if ACPI is present and active. In
> particular since _GTM will give us current modes allowing for hotplug and
> post BIOS boot kexec etc it ought to be safe to do Tejun's hack that way.
> We could even probe UDMA3+ capable devices by doing _STM to a high mode
> and _GTM to determine the cable type 8)

Glad to see the problem getting solved.  Now that we know the solution,
any volunteers?  :-)

-- 
tejun
