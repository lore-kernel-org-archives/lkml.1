Return-Path: <linux-kernel-owner+w=401wt.eu-S1765381AbZLQVUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765381AbZLQVUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765349AbZLQVUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:20:42 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43049 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765346AbZLQVUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:20:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IaVy2Nhu5oDMiyfaRpnqEqLtNXH8jKvZwkMCXGWsfEduj/eCiCM35/+kS4W6OYFqXj
         nWN7p1TlcrBRut7un33tNW9bbkInaf3suVsnqi5r7B7cHFZSiTQfH4gAs4ImN4PbTHU0
         9aSTVDuF3LZaSNlIX1ExAg4ob74U1W7b2j5gI=
MIME-Version: 1.0
In-Reply-To: <20091217211759.GB16520@n2100.arm.linux.org.uk>
References: <4B2A9F8E.5080508@gmail.com> <20091217211759.GB16520@n2100.arm.linux.org.uk>
From: roel kluin <roel.kluin@gmail.com>
Date: Thu, 17 Dec 2009 22:20:18 +0100
Message-ID: <25e057c00912171320m3c596ecancafc568cedfd70b8@mail.gmail.com>
Subject: Re: [PATCH] ARM: Wrong size used in dump_mem()
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 10:17 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Dec 17, 2009 at 10:15:58PM +0100, Roel Kluin wrote:
>> The sizeof the pointed to should be used rather than of the pointer
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>> Unless I am mistaken?
>
> You are mistaken.  sizeof(array) is the byte size of the array.
> sizeof(*array) is the size of one individual object of the array.
>
> The code is correct as is - which is to fill  the entire array with
> space characters and then zero the last one.

hmm, I see. sorry for the noise
