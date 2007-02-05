Return-Path: <linux-kernel-owner+w=401wt.eu-S964798AbXBEWAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbXBEWAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964812AbXBEWAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:00:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:1957 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964806AbXBEWAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:00:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h+8DBd5Y2m+uZnWxIJ9bZ1EexionITH1k+hegoH3TOmZmxXtHUfEpCzfJ5fD7pdEyi6dmdjDB7Rhtz2yy99HUb/Vdf3wvEXDDMblI0jO9NTp5RM4iwn7KNzNtuvBaYO4No7kEIM2vGTt1bPDKMBEXwrAJGfAjiGqNa/eH3Iz4Cw=
Message-ID: <58cb370e0702051400t2d3c08f1j83d7d1f74c36eb32@mail.gmail.com>
Date: Mon, 5 Feb 2007 23:00:18 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: Nvidia cable detection problems (was [PATCH] amd74xx: don't configure udma mode higher than BIOS did)
Cc: "Tejun Heo" <htejun@gmail.com>, "Allen Martin" <AMartin@nvidia.com>,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070205220232.3e73297b@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070205075836.GG1625@htj.dyndns.org>
	 <20070205143439.6962c076@localhost.localdomain>
	 <45C7444F.4070500@gmail.com>
	 <58cb370e0702050709w1b7682dr5dff9e7ce69465a@mail.gmail.com>
	 <DBFABB80F7FD3143A911F9E6CFD477B01EC0DD7D@hqemmail02.nvidia.com>
	 <20070205181224.3319d6c3@localhost.localdomain>
	 <45C77921.4020808@gmail.com>
	 <58cb370e0702051055w3c7dcff3wd3e3b4935b910b41@mail.gmail.com>
	 <58cb370e0702051327p7b253dafs439c937093ca837d@mail.gmail.com>
	 <20070205220232.3e73297b@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > Since we are already using UDMA mode set by BIOS to determine if 80c cable
> > is present so why not also use it to determine if the 40c cable is present?
> >
> > I mean just ignoring AMD_CABLE_DETECT register for NVIDIA devices.
> >
> > 2-lines change and we wouldn't have to deal with ACPI at ell.
>
> And as I explained earlier you get false values. The existing hack is
> dodgy as well and breaks on suspend/resume then loading the driver for
> one. It's probably the best that can be done without ACPI but the ACPI
> _GTM/_STM methods are pretty clean so its not hard to use them. You need
> them for full suspend/resume support anyway.

OK
