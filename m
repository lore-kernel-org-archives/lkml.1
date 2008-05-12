Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbYELRia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbYELRia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbYELRiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 13:38:22 -0400
Received: from zm1.veloxia.com ([213.149.227.2]:53830 "HELO zm1.veloxia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753758AbYELRiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 13:38:21 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 13:38:21 EDT
Message-ID: <48287EFB.3070303@hvsistemas.es>
Date: Mon, 12 May 2008 19:31:39 +0200
From: Javier Herrero <jherrero@hvsistemas.es>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bryan Wu <cooloney@kernel.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 1/2] [8250 Serial Driver]: Added support for 8250-class
 UARTs in HV Sistemas H8606 board
References: <1210566565-6205-1-git-send-email-cooloney@kernel.org>	<1210566565-6205-2-git-send-email-cooloney@kernel.org> <20080512105415.6a8fb88c@core>
In-Reply-To: <20080512105415.6a8fb88c@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan,

Thans, I will redo the patch in the way you suggest, test it and resend.

Regards,

Javier

Alan Cox escribió:
>>  
>> +#ifdef SERIAL_EXTRA_IRQ_FLAGS
>> +		irq_flags |= SERIAL_EXTRA_IRQ_FLAGS;
>> +#endif
>> +
>
>
> We try and keep ifdefs out of code. It is also not clear what you would
> do if you had a box where the extra flags depended on the port.
>
> So two suggestions
>
> Either
>
> Add just the line
>
> +		irq_flags |= SERIAL_EXTRA_IRQ_FLAGS;
>
> and at the end of 8250.h do
>
> #ifndef SERIAL_EXTRA_IRQ_FLAGS
> #define SERIAL_EXTRA_IRQ_FLAGS			0
> #endif
>
> or the same but with an argument (unused for now)
>
> SERIAL_EXTRA_IRQ_FLAGS(up)
>
> Alan
>
>

-- 
------------------------------------------------------------------------
Javier Herrero                            EMAIL: jherrero@hvsistemas.com
HV Sistemas S.L.                          PHONE:         +34 949 336 806
Los Charcones, 17A                        FAX:           +34 949 336 792
19170 El Casar - Guadalajara - Spain      WEB: http://www.hvsistemas.com 

