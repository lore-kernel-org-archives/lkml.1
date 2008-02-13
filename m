Return-Path: <linux-kernel-owner+w=401wt.eu-S1764894AbYBMHVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764894AbYBMHVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbYBMHVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:21:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:17759 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYBMHVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:21:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lrNxyY9HcGBe+KQVsFuY1sDa4CjtWCGCHsObNwcTOeW/vBIQw0NM1Qyof2bFuS0wV/cJ/Vj5YHDyDtaF2BQbHyp5cCQLbFxrq7JInKb8AZVpSmi5UTOiSzTQYSes7o7c0XSgyWUA0xE+2jFQR2MlfB4Qk4iZllrz2qfcdIVqK50=
Message-ID: <e9c3a7c20802122321g7241c383ofd9a3bf6f419c7c7@mail.gmail.com>
Date: Wed, 13 Feb 2008 00:21:41 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC v3 4/7] dmaengine: Add slave DMA interface
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
X-Google-Sender-Auth: d39fe62c1fb9fb18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12, 2008 9:43 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
[..]
> +enum dma_slave_direction {
> +       DMA_SLAVE_TO_MEMORY,
> +       DMA_SLAVE_FROM_MEMORY,
> +};

Just reuse enum dma_data_direction from the dma-mapping api.

--
Dan
