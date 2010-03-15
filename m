Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833Ab0COILb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 04:11:31 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:55048 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759820Ab0COIL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 04:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i43kh5S0L54CXS5IDhoe8MDgU23VYQZAbZeTibL3zGtiBR10DoafTZtgYCVwJQ/dSV
         zDOQ+TvO6AwfxlP+uUwcjkR3yYdXJB/0m7/xQ3QoH7WoGvjNCUbZjNlbZ0o+0JSLJCa2
         nwh9bzPWmjqW2piFcWOiTKJnYINhBeX0LK8o4=
MIME-Version: 1.0
In-Reply-To: <20100315030945.GS6491@shareable.org>
References: <4B968834.3040609@gmail.com>
	 <21eaeb5a1003091808s2d7638cxd524952a7d84b378@mail.gmail.com>
	 <2ea1731b1003100002w104633ffy1ae46ef3d245e5b5@mail.gmail.com>
	 <21eaeb5a1003100120x6cd3f69ak598954af3c9fe955@mail.gmail.com>
	 <2ea1731b1003100415i46dd8fcem85b85f49fb1a479@mail.gmail.com>
	 <20100312144854.cb94d9b4.akpm@linux-foundation.org>
	 <20100312233144.GG6491@shareable.org> <4B9B51B1.8010904@gmail.com>
	 <20100315030945.GS6491@shareable.org>
Date: Mon, 15 Mar 2010 09:11:27 +0100
Message-ID: <2ea1731b1003150111r74032f5fhb52ae0b6e7604800@mail.gmail.com>
Subject: Re: [PATCH v2] char drivers: Ram oops/panic logger
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yuasa Yoichi <yuasa@linux-mips.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/15 Jamie Lokier <jamie@shareable.org>:
> Marco Stornelli wrote:
>> Il 13/03/2010 00:31, Jamie Lokier ha scritto:
>> I agree, but the bootloader should be aware of it. I mean, usually
>> bootloaders at boot, reset the RAM, so you have to tell to the
>> bootloader that you are using a piece of RAM as persistent RAM, for
>> example U-Boot has got a specific option CONFIG_PRAM. I don't know if
>> all the process can be completely transparent to the admin in all
>> situations.
>
> Sometimes you can't change the bootloader (they don't always come with
> source code).  Or you could, but you don't want to risk it (there
> isn't always a way to recover if you break it).
>
> Obviously then the feature is only useful when the bootloader doesn't
> clear all the RAM :-)
>
> On slow boards in consumer devices, they sometimes avoid clearing the
> RAM because that adds measurable boot time.
>

In the embedded world, usually, you can change/write the fw and you
know well the memory map, so no problem to know the address to use. In
other cases, it can be possible to use a "transparent" approach, but
in my opinion the general approach used by the driver is enough.

Marco
