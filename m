Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZKMDNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZKMDNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 22:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbZKMDNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 22:13:41 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51337 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbZKMDNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 22:13:40 -0500
Date: Thu, 12 Nov 2009 22:09:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Janakiram Sistla <janakiram.sistla@gmail.com>
Cc: majordomo@vger.kernel.org, linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/1] Adding radio type FM
Message-ID: <20091113030950.GB4054@tuxdriver.com>
References: <4fb5db50911121909h1619e483ga4aa395af8fc1161@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4fb5db50911121909h1619e483ga4aa395af8fc1161@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 08:39:27AM +0530, Janakiram Sistla wrote:
> From 1b1493392faeb6702ff364447b135e481930b397 Mon Sep 17 00:00:00 2001
> From: Janakiram Sistla <janakiram.sistla@gmail.com>
> Date: Fri, 13 Nov 2009 08:16:26 +0530
> Subject: [PATCH 1/1] Adding radio type FM
> 
> Adding radio type FM in RFKILL_TYPE_.FM also belongs to
> same class of with both TX/RX capability.
> Also Added input type for the above same.
> 
> Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>

> @@ -290,6 +293,12 @@ static const struct input_device_id rfkill_ids[] = {
>  		.keybit = { [BIT_WORD(KEY_UWB)] = BIT_MASK(KEY_UWB) },
>  	},
>  	{
> +		.flags = INPUT_DEVICE_ID_MATCH_EVBIT |
> +				INPUT_DEVICE_ID_MATCH_KEYBIT,
> +		.evbit = { BIT_MASK(EV_KEY) },
> +		.keybit = { [BIT_WORD(KEY_UWB)] = BIT_MASK(KEY_UWB) },
> +	},

Surely this should be KEY_FM?

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
