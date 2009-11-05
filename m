Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbZKEU4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbZKEU4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbZKEU4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:56:34 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:55605 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877AbZKEU4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:56:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LKwMtaHSmuSwHNyyKdnSkqHuuuIpSTnHxl2vvrdXzSK2tHzZrpJ80drtndmoci+0Rs
         f5FKLpz5ls+V4W2jgio4AVcNKHsBX5ksB61h4WDEgMUMiR2HuH0Tw+cdllMtIya8nJPy
         PRRp4Q3R2kNYg1itwhKn0LFf4yIxIUV8Flk+M=
Message-ID: <4AF33C02.6040606@gmail.com>
Date: Thu, 05 Nov 2009 21:56:34 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090926 Lightning/1.0pre Shredder/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 40/41] rt2800: add rt2800lib (part three)
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173657.28463.90918.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173657.28463.90918.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/09 18:36, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800: add rt2800lib (part three)
> 
> Code unification.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

I wonder how many differences we are going to get between rt2800pci and rt2800usb with respect to register settings, but this is good enough for now. When the differences turn out to be too big, we can always move the affected functions into rt2800_ops and let each driver provide his own version.

