Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbYA3NJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbYA3NJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757208AbYA3NJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:09:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:43839 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbYA3NJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:09:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EtrDCest58UC+vRrV7RRG4NzO7xXXXNp12YuWKnfI84ufVDobdURp6/8Yj5Bp99g8dpEgNd8Qm4bQyoEjLoBrUNMed5oyO5AUVtfUElmEOfk2qjrjl0scYYc9CGOeeOLnbBcG3DILDD/+NhNj66cNhj9yCjbRzrMgLftWh/L/iE=
Message-ID: <47A076EB.9020401@gmail.com>
Date: Wed, 30 Jan 2008 14:08:59 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robin Getz <rgetz@blackfin.uclinux.org>
CC: Bryan Wu <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       Mike Frysinger <michael.frysinger@analog.com>
Subject: Re: [PATCH 1/1] [Blackfin] char driver for Blackfin on-chip OTP memory
References: <1201689401-2892-1-git-send-email-bryan.wu@analog.com> <47A058B3.6000009@gmail.com> <200801300739.21344.rgetz@blackfin.uclinux.org>
In-Reply-To: <200801300739.21344.rgetz@blackfin.uclinux.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2008 01:39 PM, Robin Getz wrote:
> On Wed 30 Jan 2008 06:00, Jiri Slaby pondered:
>> On 01/30/2008 11:36 AM, Bryan Wu wrote:
>>> From: Mike Frysinger <michael.frysinger@analog.com>
>>>
>>> initial char driver for otp memory
>>> (only read supported atm ... needs real examples/docs for write support)
>>>
>>> Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
>>> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> 
>>> +	bfin_otp_class = class_create(THIS_MODULE, "otp");
>>> +	device_create(bfin_otp_class, NULL, bfin_otp_dev_node, "otp");
>> Anyway, wouldn't be easier/better to use misc.c functionality here 
>> (misc_register() et al.)?
> 
> OTP (one time programmable) memory are not registers, they are small blocks 
> (8k bytes) of non violate on chip memory, for storing things that you don't 
> want other people to look at via a PCB level probe. (like keys), or things 
> that are just helpful - like MAC addresses.

Sorry, misc_register() allows you to get rid of the chrdev initialization 
including class creation. Maybe I'm not understanding what you are trying to 
explain me?
