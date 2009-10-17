Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbZJQHrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbZJQHrw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 03:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZJQHrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 03:47:52 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:37702 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbZJQHrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 03:47:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=m7OJF987qpq1aR/mlwZxikqQ5nkfB9ItM4qDAxAHIge73Um1rh2nLdKo5k95xM+8WA
         HKvolN/G7DPZYe+SlhHB4PCxXYpL1Tj6STxeWWkXDH6tFQvIor9P5JstUEp/jboAfGY8
         0tY8oe8fGEevEg6R9WMmiXw9fKdSfL+LczV90=
MIME-Version: 1.0
In-Reply-To: <804dabb00910162243m47c038e3xa744ab165317b300@mail.gmail.com>
References: <804dabb00910162243m47c038e3xa744ab165317b300@mail.gmail.com>
Date: Sat, 17 Oct 2009 03:40:19 -0400
Message-ID: <804dabb00910170040v27feb935mc95a751b0b7b4086@mail.gmail.com>
Subject: Re: booting up: blocking indefinitely on kgdb?
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry....now I reboot it is ok.   I don't know why. sorry about that.

On Sat, Oct 17, 2009 at 1:43 AM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> Today, both my system (2.6.32.-rc4 from linus git tree and linux-next)
> bootup blocked indefinitely on:
>
> kgdb: Registered I/O driver kgdbts.
>
> while booting up.   The expected line:
>
> kgdb: Unregistered I/O driver kgdbts, debugger disabled.
>
> never comes up.
>
> My bootup menu.lst:
>
> title Fedora (2.6.26-rc4-next-20080530)
>        root (hd1,7)
>        kernel /boot/vmlinuz-2.6.26-rc4-next-20080530 ro
> root=UUID=d10fe8db-e7d4-4b42-b265-0109a3f3eedf
>        initrd /boot/initrd-2.6.26-rc4-next-20080530.img
> title Fedora (2.6.32-rc4)
>        root (hd1,7)
>        kernel /boot/vmlinuz-2.6.32-rc4 ro
> root=UUID=d10fe8db-e7d4-4b42-b265-0109a3f3eedf
>        initrd /boot/initrd-2.6.32-rc4.img
>
> and kgdb-related option:
>
> CONFIG_HAVE_ARCH_KGDB=y
> CONFIG_KGDB=y
> CONFIG_KGDB_SERIAL_CONSOLE=y
> CONFIG_KGDB_TESTS=y
> CONFIG_KGDB_TESTS_ON_BOOT=y
> CONFIG_KGDB_TESTS_BOOT_STRING="y"
>
> The same 2.6.32-rc4 image have bootup previously before without any
> problem.   So what could be the potential cause of this permanent
> wait?
>
> --
> Regards,
> Peter Teoh
>



-- 
Regards,
Peter Teoh
