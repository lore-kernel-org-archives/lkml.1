Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbZFVEsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbZFVEsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 00:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZFVEsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 00:48:35 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:44903 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZFVEse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 00:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eK9Ks2ToHsCsVHQfTLnbrd9PqQ8+fxjaiVuOlnL+2zCkISUlaOiPk0aZuBTPD8Y0ZN
         5TV8+569Q8PphekWhY69fZR+T3AzxRwwF7HPi/THte+JukIP1/qkLUysaxWEze/k81FA
         zyl3wuB7tNjMCZzYL8Oq9eLH8OFBazX/S6BeU=
MIME-Version: 1.0
In-Reply-To: <20090621183658.2b408e69@lappy.seanm.ca>
References: <20090620154824.72b5cd50@lappy.seanm.ca>
	 <200906202256.46073.elendil@planet.nl>
	 <20090620194250.5a3e826f@lappy.seanm.ca>
	 <200906210628.35553.elendil@planet.nl>
	 <84144f020906210320n2984807dw2d4b4fb38afd22cf@mail.gmail.com>
	 <1245623104.16880.26.camel@pasglop>
	 <20090621183658.2b408e69@lappy.seanm.ca>
Date: Mon, 22 Jun 2009 07:48:35 +0300
X-Google-Sender-Auth: c942a96535f8e1aa
Message-ID: <84144f020906212148y77a05be6k8f96beb3cf31da2b@mail.gmail.com>
Subject: Re: Badness on the Warp
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Sean MacLennan <smaclennan@pikatech.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frans Pop <elendil@planet.nl>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       David Gibson <david@gibson.dropbear.id.au>,
       Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sean,

On Mon, Jun 22, 2009 at 1:36 AM, Sean MacLennan<smaclennan@pikatech.com> wrote:
> On Mon, 22 Jun 2009 08:25:04 +1000
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
>> Right, our interrupt controllers need those fixes, they are low
>> on my priority list since it's a reasonably harmless warning and I'm
>> still chasing some actual breakage (though maybe not directly related
>> to your patches).
>>
>> Kumar already submitted a couple, Frans, feel free to beat me
>> at converting UIC (just use kmalloc directly in there instead
>> of alloc_bootmem).
>
> I can make the changes to UIC if you want. They badness is harmless (it
> ends up calling kzalloc anyway), but hard to explain to our PV (Product
> Verification) department that they can ignore what looks like a crash ;)

Right. We can also wrap the WARN_ON() in CONFIG_DEBUG_BOOTMEM or
something too but I'd prefer a proper fix here.

                                   Pekka
