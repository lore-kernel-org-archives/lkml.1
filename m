Return-Path: <linux-kernel-owner+w=401wt.eu-S935879AbZLPXAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935879AbZLPXAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964880AbZLPXAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:00:34 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54397 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964869AbZLPXA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:00:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uqSryKAQ+ev9l2mke4nc/5XkzveSKGSQ5gnBlaMMijb0rWvYpnq56FT5rxCZUfb2z2
         85lFdLh3YZ9zfQPVjQy2C4AEFSr3cT4PoBC7aucbjuLKgBQUV83L9Vvgv1jUR6Pov8I6
         kxvupCWyuZfgDBQNDE1Pfnqx0Rgcr3rRo1yV4=
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200ED81@mi8nycmail19.Mi8.com>
References: <1253224997-7422-1-git-send-email-vapier@gentoo.org> 
	<BD79186B4FD85F4B8E60E381CAEE19090200ED81@mi8nycmail19.Mi8.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Dec 2009 18:00:04 -0500
Message-ID: <8bd0f97a0912161500h1dd95f1cr7a978b67ab6278b4@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH 1/2] spi: new SPI bus 
	lock/unlockfunctions
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       Yi Li <yi.li@analog.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 17:49, H Hartley Sweeten wrote:
> On Thursday, September 17, 2009 3:03 PM, Mike Frysinger wrote:
>>
>> From: Yi Li <yi.li@analog.com>
>>
>> For some MMC cards over SPI bus, it needs to lock the SPI bus for its own
>> use.  The SPI transfer must not be interrupted by other SPI devices that
>> share the SPI bus with SPI MMC card.
>>
>> This patch introduces 2 APIs for SPI bus locking operation.
>
> Has any additional work be done on this patchset?

nope

> It would be nice to finally have a solution that lets the mmc_spi driver
> work on a shared spi bus.

the latest patch is on the list for _anyone_ to contribute their fixes
to address the posted issues
-mike
