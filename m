Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZGIS3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZGIS3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 14:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZGIS3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 14:29:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:49670 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbZGIS3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 14:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Hv+SRHOJHyZZIu+SMc2MyBLzUrApX8dM8rH9IvQNqx4zJ8J1mCWQh7msauhlfp0dyI
         TJTgXymjDypWAVkDUCHtgoEun3MvAoB9DW3AItQrWnpBrn1CUbiuHDdryf1jOnyr1IBx
         BqmCddsq0HA+D/XNlFc6h0luNYuk3RSGvS2JA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0907092016360.2768@localhost.localdomain>
References: <1247063308.4382.12.camel@ht.satnam>
	 <1247065179.4382.51.camel@ht.satnam> <20090709162807.GD5208@lenovo>
	 <alpine.LFD.2.00.0907092016360.2768@localhost.localdomain>
Date: Thu, 9 Jul 2009 21:29:12 +0300
X-Google-Sender-Auth: e3e81f372aafedb2
Message-ID: <84144f020907091129q14880d4aqeae964621f8e6ca8@mail.gmail.com>
Subject: Re: [PATCH 20/44] includecheck fix: x86, shadow.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> On Thu, 9 Jul 2009, Cyrill Gorcunov wrote:
>> |  #include <linux/kmemcheck.h>
>> |  #include <linux/module.h>
>> |  #include <linux/mm.h>
>> | -#include <linux/module.h>
>> |
>> |  #include <asm/page.h>
>> |  #include <asm/pgtable.h>
>> | --
>> | 1.6.0.6
>> |
>>
>> Better to CC Vegard on this.

On Thu, Jul 9, 2009 at 9:18 PM, Thomas Gleixner<tglx@linutronix.de> wrote:
> Can we stop this kindergarden already? The patch is so obvious that it
> just should be applied. I'll pick up all x86 ones and fold them in.

What kindergarten are you talking about? Technically Ingo "kicked"
kmemcheck out of the x86 tree so the patch should go through
kmemcheck.git which makes Cyrill's CC correction spot on.

                        Pekka
