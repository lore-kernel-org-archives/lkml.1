Return-Path: <linux-kernel-owner+w=401wt.eu-S1762801AbZEHMYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762801AbZEHMYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZEHMYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:24:11 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:56708 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZEHMYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:24:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WiYZBKAaAOQ7LhAg7zWXdcfEsBkxHt1w2Qk7R5H7Ji8TuszNKXavonCM2cKKvgT56K
         93Tkjh7zuTXUCJHwaennURO4C1SkUZ9gBT2IVo2qX3rXLNfZsJkQKP5PJaBtobGVLjmA
         EOi2l01E3sXERwPMjiKmBeds9KQDkqOr59UXQ=
MIME-Version: 1.0
In-Reply-To: <a276da400905072340j6130615bu3ef524be5bd48143@mail.gmail.com>
References: <20090506222439.GB22327@kroah.com>
	 <a276da400905070451j550d9a9ajcdd3ab30b03278aa@mail.gmail.com>
	 <20090508040101.GC31689@kroah.com>
	 <a276da400905072340j6130615bu3ef524be5bd48143@mail.gmail.com>
Date: Fri, 8 May 2009 20:24:10 +0800
Message-ID: <a276da400905080524o1a56b895ldc2788458deaf1ff@mail.gmail.com>
Subject: Re: usbutils 0.82 release
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 8, 2009 at 2:40 PM, Xiaofan Chen <xiaofanc@gmail.com> wrote:
> On Fri, May 8, 2009 at 12:01 PM, Greg KH <greg@kroah.com> wrote:
>> On Thu, May 07, 2009 at 07:51:23PM +0800, Xiaofan Chen wrote:
>>> Not sure if this is a real problem or not. There is a compiler warning
>>> for gcc 4.4.0.
>>>
>>> gcc -DHAVE_CONFIG_H -I.   -DDATADIR=\"/usr/share\"   -g -O2 -MT
>>> lsusb-names.o -MD -MP -MF .deps/lsusb-names.Tpo -c -o lsusb-names.o
>>> `test -f 'names.c' || echo './'`names.c
>>> names.c: In function ‘names_init’:
>>> names.c:803: warning: assignment makes pointer from integer without a cast
>>
>> Care to provide a patch for this?
>
> To be honest, I do not know the reason of the warning. It looks fine to me
> but I am not a real programmer.
>
> In fact, I tried version 0.73 and there is no warning there and the file name.c
> is the same between 0.73 and 0.81/0.82.
>

I still do not know the exact reason but it seems to be related to the
generated config.h file or zlib.

If I use the file config.h from 0.73, there will be no warning. It is
longer than the one generated in 0.82 or git.

And if I undefine HAVE_LIBZ in names.c, there will be no warning.

The warning is not only in gcc 4.4.0, but also in gcc 4.3.3.

-- 
Xiaofan http://mcuee.blogspot.com
