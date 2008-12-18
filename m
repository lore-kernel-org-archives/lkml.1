Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753539AbYLRU5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbYLRU5T (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYLRU44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:56:56 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:34360 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYLRU4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:56:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a4BSOkxcX1WAyVVcdxx62FCM0lmCvd2oudoxVZRyXbH4LAQP1H4XaNnhwCqcz+Jh6Y
         a63IaETFuDZ3YieDsn/6YzviZoc1pWycysjRzJedtItDfh2O109r5Bzy0pUjS9IgaTGt
         Rdc9rA1RejZu/OnWwvRu/XpoN5Z+nfWf+hVLk=
Message-ID: <8bd0f97a0812181256j68326d28t15cf4370571b04bd@mail.gmail.com>
Date: Thu, 18 Dec 2008 15:56:53 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Samuel Ortiz" <sameo@openedhand.com>
Subject: Re: section mismatches with _sm501_register_gpio() and _sm501_gpio_register_chip()
Cc: ben@simtec.co.uk, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081124194911.GC2604@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0811202013r170c9906i15797ca953844cff@mail.gmail.com>
	 <20081124194911.GC2604@sortiz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 14:49, Samuel Ortiz wrote:
> On Thu, Nov 20, 2008 at 11:13:31PM -0500, Mike Frysinger wrote:
>> WARNING: drivers/mfd/built-in.o(.text+0x8d6): Section mismatch in
>> reference from the function _sm501_register_gpio() to the function
>> .devinit.text:_sm501_gpio_register_chip()
>> The function _sm501_register_gpio() references
>> the function __devinit _sm501_gpio_register_chip().
>> This is often because _sm501_register_gpio lacks a __devinit
>> annotation or the annotation of _sm501_gpio_register_chip is wrong.
>>
>> WARNING: drivers/mfd/built-in.o(.text+0x90a): Section mismatch in
>> reference from the function _sm501_register_gpio() to the function
>> .devinit.text:_sm501_gpio_register_chip()
>> The function _sm501_register_gpio() references
>> the function __devinit _sm501_gpio_register_chip().
>> This is often because _sm501_register_gpio lacks a __devinit
>> annotation or the annotation of _sm501_gpio_register_chip is wrong.
>
> Which kernel are you triggering this on ?

sorry, i missed this response ... this was in 2.6.28-rc2
-mike
