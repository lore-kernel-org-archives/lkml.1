Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358Ab0AUEOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab0AUEOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737Ab0AUEOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:14:21 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:51423 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab0AUEOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:14:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vbS7PWOGqAiz7VVZJ3HsJJ91VgfD0EkZE7fyhWq7SopFJLkinveZJWfpKO9tVfbFer
         1AKN9WKLBhg9XlAZ/5zq12LhkQHlH2J3g+hF1JqsHV/rSWYjI3J1yYMPqvfiqOqqBmt8
         KJW7ZZHe4CT+blgk01WamXghim+Pe/H61kSf0=
Message-ID: <4B57D492.1060508@garzik.org>
Date: Wed, 20 Jan 2010 23:14:10 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/64] pata_cmd64x: fix PIO setup
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171455.14623.81852.sendpatchset@localhost>
In-Reply-To: <20100118171455.14623.81852.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 12:14 PM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_cmd64x: fix PIO setup
>
> Fix incorrect handling of recovery clocks value == 16 resulting
> in overclocked recovery timings&  potentially underclocked active
> timings.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_cmd64x.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)

applied 8-11


