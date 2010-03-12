Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab0CLToj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 14:44:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46859 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab0CLToh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 14:44:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qFgroZeY/vun5UgKVowXdNI5Wl6A9Sf5IWhF72vzt1q4laFIufaZP5cCkxEkY7C3v1
         QD0+e7uXFZk2g/FtR/bNb4Vx8iWQrOVx6nxzh8prg9hC1zvIh4EOqzd41rIvj1qItSs9
         wA515ViHnYTqNxavIfeUzUodHbE1xd9OUCcY4=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>
	 <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>
	 <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan>
	 <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan>
	 <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>
Date: Fri, 12 Mar 2010 11:44:37 -0800
X-Google-Sender-Auth: a72ab8d878744e82
Message-ID: <86802c441003121144y24e763e6n16f237928df1f676@mail.gmail.com>
Subject: Re: 2.6.33: pci 0000:00:00.0: address space collision / spontaenous 
	reboots
From: Yinghai Lu <yinghai@kernel.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 4:56 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>
>>
>>
>> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>>
>> Problem persists.
>>
>> Others seem to have similar issues:
>> http://lkml.org/lkml/2010/1/9/157
>>
>> Some boards not compatible it appears..
>>
>> Justin.
>>
>>
>
> Even with all boards removed:
> [    0.133537] pci 0000:00:00.0: address space collision: [mem
> 0xe0000000-0xffffffff 64bit] already in use
>
> 00:00.0 Host bridge: ATI Technologies Inc RD790 Northbridge only dual slot
> PCI-e_GFX and HT3 K8 part
>

how about current linus' tree with pci=nocrs or pci=use_crs?

YH
