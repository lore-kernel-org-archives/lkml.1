Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab0BEQEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 11:04:32 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:62211 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab0BEQEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 11:04:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fM84mBa9/aHBKgQ9biJm0tqeQSc440H6H4kUhW0/eP4KXR4qfW5JDYvp8OW4wjeLep
         cfwFfdpppQqYlJIZSFqpGUaC8VIZGXpNDP4/RmE0UPJ28ARLE8RFdATAMkUMsGD0HbeU
         aF+Cmk4JCzIQwo5CRbapqZXhjjx37RohfDqn8=
MIME-Version: 1.0
In-Reply-To: <201002040832.09805.arnd@arndb.de>
References: <201001302257.09354.arnd@arndb.de>
	 <520f0cf11002011518y22c2f097s87872e7b5b1690d7@mail.gmail.com>
	 <20100203050749.GA22110@core.coreip.homeip.net>
	 <201002040832.09805.arnd@arndb.de>
Date: Fri, 5 Feb 2010 17:04:28 +0100
X-Google-Sender-Auth: 4f06c5b51a6174d1
Message-ID: <520f0cf11002050804r184dc59bha6ba8b78e7f75909@mail.gmail.com>
Subject: Re: [PATCH] input: remove BKL from uinput open function
From: John Kacur <jkacur@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 8:32 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 03 February 2010, Dmitry Torokhov wrote:
>> OK, so how about the patch below? If it is accepted I will just switch
>> to
>>
>>         nonseekable_open(inode, file);
>>         return 0;
>>
>> style. I gonna add Al and akpm to CC to see if the patch will stick...
>
> Sounds reasonable, if only to prevent this from becoming a FAQ.
>
>> VFS: clarify that nonseekable_open() will never fail
>>
>> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> --

Acked-by: John Kacur <jkacur@redhat.com>
