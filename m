Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbZFYIro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbZFYIro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZFYIrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:47:36 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:62692 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZFYIre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j9DIEuTIRjSZEiIvqe31cq4utB5ExEURQhxPCCd2HgKLoX60pykATHV8Tsu8MDJB8Q
         BGQOqE0S5P+27MRG8ySUjQt/HzxuY6hZWx79HBEZY1gBPRhaY/gEiQN/4QvtyW76yRA1
         zjkwovt1ryfCasvAoAD2ipihFsYsJTavhP5Z8=
MIME-Version: 1.0
In-Reply-To: <1245917167.17089.102.camel@macbook.infradead.org>
References: <f69abfc30906250042g4e6cec13n1a25f4b04ce5177c@mail.gmail.com>
	 <1245917167.17089.102.camel@macbook.infradead.org>
Date: Thu, 25 Jun 2009 10:47:33 +0200
Message-ID: <f69abfc30906250147n7e0b2945x50af858f52adb904@mail.gmail.com>
Subject: Re: Add support for the SST 39VF3202, 39VF6401B and 39VF6402B flash 
	chips
From: Yegor Yefremov <yegorslists@googlemail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Add support for the SST 39VF3202, 39VF6401B and 39VF6402B flash chips
>>
>> - extend struct amd_flash_info to enable 8 erase regions for 8Mb flash chips
>
> If you didn't mean 8,000,000 bits, don't say it. Did you mean 8MiB?

Sure I mean 8MiB

>> - change erase block command to 0x50 due to the differences between
>> 39VF6401/02 and 39VF6401B/02B chips
>
> Hm, can you elucidate?

Please refer to the data sheets Table 6:
39VF6401B data sheet http://www.sst.com/downloads/datasheet/S71288.pdf
39VF6401 data sheet http://www.sst.com/downloads/datasheet/S71223-03.pdf

The difference in the 6th bus write cycle. 39VF6401B uses 0x50 and
39VF6401 uses 0x30.

> And should that be done as a quirk instead?

How should I do it? The commend is not a part of any structure. Can we
add such a field to the  struct amd_flash_info describing erase
sequence?

Yegor
