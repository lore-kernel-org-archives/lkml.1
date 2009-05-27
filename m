Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbZE0R4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbZE0R4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932731AbZE0RxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:53:10 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:38230 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764255AbZE0RxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:53:09 -0400
MIME-Version: 1.0
In-Reply-To: <20090527174440.GA31861@flint.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> 
	<20090527174440.GA31861@flint.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 May 2009 11:52:50 -0600
Message-ID: <fa686aa40905271052k3f55eb73k2cb0c3cff3c94d7b@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       jwboyer@linux.vnet.ibm.com, paulus@samba.org,
       devicetree-discuss <devicetree-discuss@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 11:44 AM, Russell King
<rmk+lkml@arm.linux.org.uk> wrote:
> (For whatever reason, I don't have the initial email on this.)
>
> On Wed, May 27, 2009 at 08:27:10AM -0600, Grant Likely wrote:
>> On Wed, May 27, 2009 at 1:08 AM, Janboe Ye <yuan-bo.ye@motorola.com> wrote:
>> > Hi, All
>> >
>> > Currently, ARM linux uses mach-type to figure out platform. But mach-type could not handle variants well and it doesn't tell the kernel about info about attached peripherals.
>> >
>> > The device-tree used by powerpc and sparc could simplifiy board ports, less platform specific code and simplify device driver code.
>> >
>> > Please reference to Grant Likely and Josh Boyer's paper, A Symphony of Flavours: Using the device tree to describe embedded hardware , for the detail of device tree.
>> >
>> > www.kernel.org/doc/ols/2008/ols2008v2-pages-27-38.pdf
>> >
>> > Signed-off-by: janboe <yuan-bo.ye@motorola.com>
>>
>> Heeheehe, This is Fantastic.  I'm actually working on this too.  Would
>> you like to join our efforts?
>
> My position is that I don't like this approach.  We have _enough_ of a
> problem getting boot loaders to do stuff they should be doing on ARM
> platforms, that handing them the ability to define a whole device tree
> is just insanely stupid.

The point of this approach is that the device tree is *not* create by
firmware.  Firmware can pass it in if it is convenient to do so, (ie;
the device tree blob stored in flash as a separate image) but it
doesn't have to be and it is not 'owned' by firmware.

It is also true that there is the option for firmware to manipulate
the .dts, but once again it is not required and it does not replace
the existing ATAGs.

If a board port does get the device tree wrong; no big deal, we just
fix it and ship it with the next kernel.

> The end story is that as far as machine developers are concerned, a
> boot loader, once programmed into the device, is immutable.  They never
> _ever_ want to change it, period.

I agree 100%.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
