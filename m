Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXLJIYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXLJIYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 03:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXLJIX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 03:23:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:45402 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXLJIX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 03:23:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Lf8botR4XCOpPeSx8rhWlJSLVevgM/2RhdNOmvm3vuEpfNiNYCfx1ucDXgt37pmPZ5aUQYjBIR4fK1mGTkvpL0Xecc8wAWiPf5QUNOdinh4TokAyy0xWzUlRCiT+RVmj6HXx2D8eyBq909kkq/citwSr3R698hRtBJIosSODnJI=
Message-ID: <475CF78B.3040404@gmail.com>
Date: Mon, 10 Dec 2007 17:23:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org, apiszcz@solarrain.com
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan> <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712010722590.28887@p34.internal.lan> <20071201174733.646a5c35@absurd> <Pine.LNX.4.64.0712011155110.6257@p34.internal.lan> <Pine.LNX.4.64.0712020409280.30169@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0712020409280.30169@p34.internal.lan>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> The badblocks did not do anything; however, when I built a software raid
> 5 and the performed a dd:
> 
> /usr/bin/time dd if=/dev/zero of=fill_disk bs=1M
> 
> [42332.936615] ata5.00: exception Emask 0x2 SAct 0x7000 SErr 0x0 action
> 0x2 frozen
> [42332.936706] ata5.00: spurious completions during NCQ issue=0x0
> SAct=0x7000 FIS=004040a1:00000800
> 
> Next test, I will turn off NCQ and try to make the problem re-occur.
> If anyone else has any thoughts here..?
> I ran long smart tests on all 3 disks, they all ran successfully.
> 
> Perhaps these drives need to be NCQ BLACKLISTED with the P35 chipset?

That was me being stupid.  Patches for both upstream and -stable
branches are posted.  These will go away.

Thanks.

-- 
tejun
