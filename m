Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbXLVBtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbXLVBtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbXLVBtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:49:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbXLVBtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:49:06 -0500
Message-ID: <476C6D06.2070301@zytor.com>
Date: Fri, 21 Dec 2007 17:48:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: devzero@web.de, linux-kernel@vger.kernel.org, Matt.Domsch@dell.com
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
References: <49015158@web.de> <47656B9E.3040405@zytor.com> <p73sl1vedhw.fsf@bingen.suse.de>
In-Reply-To: <p73sl1vedhw.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> devzero@web.de wrote:
>>>         /* Query EDD information */
>>>  #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
>>> -       query_edd();
>>> +        printf("Probing EDD (query Bios for boot-device information)\n");
>>> +        printf("If boot hangs here, you may have a buggy Bios. Try edd=skipmbr or edd=off");
>>> +        query_edd();
>>> +        printf("\rOK                                                                       \n");
>>>  #endif
>> This is awfully verbose.
> 
> But useful. On the other hand we have lots of IMNSHO
> quite useless printks in early bootup that could be removed
> to make up for that
> 
> (e.g. candidates would be the 
> "CPU: After/before generic identify"
> or 
> Entering add_active_range....) 
> 
> printks and you can easily make up for the added verbosity.
> 

Those don't live in an area of memory which is hard-limited to 32K.

	-hpa
