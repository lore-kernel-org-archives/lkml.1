Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0BDEfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 23:35:33 -0500
Received: from mail.crca.org.au ([67.207.131.56]:35519 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195Ab0BDEf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 23:35:28 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4B6A4F07.3090509@crca.org.au>
Date: Thu, 04 Feb 2010 15:37:27 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-crypto@vger.kernel.org,
       TuxOnIce Devel List <tuxonice-devel@lists.tuxonice.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: LZO irreversible output?
References: <4B69ECE5.5060505@crca.org.au> <201002032354.11284.rjw@sisk.pl>
In-Reply-To: <201002032354.11284.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.

Rafael J. Wysocki wrote:
> On Wednesday 03 February 2010, Nigel Cunningham wrote:
>> Hi all.
>>
>> (Not sent to LKML yesterday; no reply from linux-crypto yet, so resending).
>>
>> A while back now, I stopped supplying the LZF compression algorithm with
>> TuxOnIce and made LZO the default algorithm. Around the same time, we
>> started getting occasional errors when reading images; decompression
>> failures.
>>
>> I've finally managed to find the time to properly look at this, and have
>> managed to find a data page that LZO compresses, but seems to be unable
>> to decompress back to the original contents. I'm wondering whether this
>> is because I'm doing something wrong, or because there really is some
>> data the LZO (or the kernel implementation) can't do reversible
>> compression on.
> 
> Well, FWIW, we have never had any problems with the userland LZO in s2disk,
> so if anything is wrong with LZO here, I guess it's the kernel code.

Okay. Guess I have to start shipping LZF again and make it the default
again then.

Regards,

Nigel
