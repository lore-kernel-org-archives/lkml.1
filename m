Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbZBNLAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbZBNLAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 06:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZBNLAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 06:00:36 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:48036 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZBNLAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 06:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jsDqHwhT2r0uAmIsfCEbEQV1e83cjT+ZsE7SS0kkiMHGoBtp6jKQCpp9Ynk8N53Ibb
         QbelnTBoJgI1ZujyH9ZFTOTG9M/E3x5CxsUDSbsT9kh3/p/fnd1ASl3UvdrguCok2mB4
         vWMhOicN0v23zsxYUTIZXjUsIAngyZ94D+vuU=
MIME-Version: 1.0
In-Reply-To: <20090214102704.GB29771@ioremap.net>
References: <20090213150654.GA7390@orion> <20090214102704.GB29771@ioremap.net>
Date: Sat, 14 Feb 2009 14:00:33 +0300
Message-ID: <a4423d670902140300k1aa3f2ccp8961f005cb020723@mail.gmail.com>
Subject: Re: [PATCH next] Staging: pohmelfs should depend on CRYPTO
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: gregkh@suse.de, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/14 Evgeniy Polyakov <zbr@ioremap.net>:
> On Fri, Feb 13, 2009 at 06:06:54PM +0300, Alexander Beregalov (a.beregalov@gmail.com) wrote:
>>
>>
>> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>
> Doesn't subsystem selection also forces higher level selection, i.e.
> selecing CRYPTO_BLKCIPHER also forces CRYPTO selection? If it is not the
> case, then your patch is definitely valid.
No, it does not. The kernel fails to build if CRYPTO was disabled
before enabling POHMELFS.
>
>> ---
>>
>>  drivers/staging/pohmelfs/Kconfig |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/staging/pohmelfs/Kconfig b/drivers/staging/pohmelfs/Kconfig
>> index f150ecb..4c6276b 100644
>> --- a/drivers/staging/pohmelfs/Kconfig
>> +++ b/drivers/staging/pohmelfs/Kconfig
>> @@ -1,6 +1,7 @@
>>  config POHMELFS
>>       tristate "POHMELFS filesystem support"
>>       select CONNECTOR
>> +     select CRYPTO
>>       select CRYPTO_BLKCIPHER
>>       select CRYPTO_HMAC
>>       help
>
> --
>        Evgeniy Polyakov
>
