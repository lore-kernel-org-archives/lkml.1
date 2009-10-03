Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbZJCQrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbZJCQrZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 12:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZJCQrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 12:47:25 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:60003 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZJCQrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 12:47:24 -0400
References: <4AC34B83.6090402@canonical.com> <20090930212233.GB17712@liondog.tnic> <cone.1254466252.404216.3290.1000@onepiie> <4AC5B0F1.4030303@canonical.com> <9ea470500910020254j21fad1d3g1c825bcecdbb29fb@mail.gmail.com> <cone.1254477850.9043.3499.1000@onepiie> <4AC5D098.1010504@canonical.com>
Message-ID: <cone.1254588453.335375.3174.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acerhdf: Limit modalias matching to supported boards
Date: Sat, 03 Oct 2009 18:47:33 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Bader writes:

> Peter Feuerer wrote:
>> Borislav Petkov writes:
>> 
>>> On Fri, Oct 2, 2009 at 9:51 AM, Stefan Bader 
>>> <stefan.bader@canonical.com> wrote:
>>>>>> I search my acerhdf-inbox for the people who sent me the BIOS 
>>>>>> versions,
>>>>> maybe they still have the netbook and can me send the modalias 
>>>>> content. I'll
>>>>> hopefully find some time upcoming weekend.
>>>>>
>>>>> But, can't we simply assume, following dmi lines?
>>>>>
>>>>> MODULE_ALIAS("dmi:*:*Acer*:*AOA*:");
>>>>> MODULE_ALIAS("dmi:*:*Gateway*:*AOA*:");
>>>>> MODULE_ALIAS("dmi:*:*Packard Bell*:*AOA*:");
>>>>> MODULE_ALIAS("dmi:*:*Packard Bell*:*DOA*:");
>>>>>
>>>>> We have exactly those constellations within the BIOS settings table. 
>>>>> If I
>>>>> interpret the modalias line correctly, "pnAOA110" means "Product Name
>>>>> AOA110" and that's what we have already in the BIOS settings table. 
>>>>> So I
>>>>> think we do already have all information we need to create a 
>>>>> complete patch
>>>>> for the problem, or am I wrong?
>>>>
>>>> Right pn means that. I would strongly believe the above changes 
>>>> should be
>>>> good. I sometimes tend to be over-cautious. Attaching a refreshed patch
>>>> which includes them all.
>>>
>>> Well, acerhdf.c and dmi-id.c both do
>>> dmi_get_system_info(DMI_PRODUCT_NAME) when querying product name which
>>> means that the product names in the acerhdf table and the dmi-id ones
>>> are actually one and the same thing.
>>>
>>> IMO, we should just go ahead send it to Len. Stefan, you have my ACK.

Acked-by: Peter Feuerer <peter@piie.net>

Thank you Stefan!

regards,
--peter
