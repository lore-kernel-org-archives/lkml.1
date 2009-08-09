Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZHIJTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZHIJTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 05:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZHIJTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 05:19:53 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:46156 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbZHIJTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 05:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wBfnonzoeziqckN1aMghhwKtHmgFaynfYy/SCWFEvnucyy4AS4a3V5Sn+f7qIRmZDo
         n3QLdFq//52l2FBUYk+t1jEb/8u1/8DGFliEuh3sMIKTuYK0/W6TpUcgY+Zr4iGl1Ot/
         5bZ5cdcUoIo6Jp+FBfpOEct2AM0iCNTX4bas8=
Message-ID: <4A7E9596.4070901@gmail.com>
Date: Sun, 09 Aug 2009 11:23:34 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Daniel Mack <daniel@caiaq.de>, "John W. Linville" <linville@tuxdriver.com>,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Libertas: Association request to the driver failed
References: <20090807191156.GS19257@buzzloop.caiaq.de> <20090807193610.GK7545@tuxdriver.com> <20090808123512.GZ19257@buzzloop.caiaq.de> <4A7D8AB6.9030707@gmail.com>
In-Reply-To: <4A7D8AB6.9030707@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> The change came in after -rc5,
>> and I found 57921c31 ("libertas: Read buffer overflow") to be the
>> culprit. Reverting it brings my libertas device back to life. I copied
>> the author.
>>
>> Thanks,
>> Daniel
> 
> Ah, I think I made an error, I think tmp is too small and should be
> 
> u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates) - 1];

After some sleep I realized it should be:

u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates)];


> Sorry and thanks for testing,
> 
> Roel
