Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbZARVPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbZARVPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 16:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZARVPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 16:15:43 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:20585 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489AbZARVPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 16:15:41 -0500
Message-ID: <49739BFA.4030609@msgid.tls.msk.ru>
Date: Mon, 19 Jan 2009 00:15:38 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Jan Engelhardt <jengelh@medozas.de>,
       Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk>	<20080226112840.GA29465@uranus.ravnborg.org>	<alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr>	<20081226194833.GA8306@uranus.ravnborg.org>	<alpine.LSU.2.00.0812262049040.12031@fbirervta.pbzchgretzou.qr>	<20090118210416.GE2978@uranus.ravnborg.org> <20090118130908.390eb07b@infradead.org>
In-Reply-To: <20090118130908.390eb07b@infradead.org>
X-Enigmail-Version: 0.95.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 18 Jan 2009 22:04:16 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
[]
>> Can I ask you to redo this patch.
>> I want a way to swith off compression, but it should default be
>> enable. So if KBUILD_MODULE_NOCOMPRESS is undefined we will compress
>> the modules when we install them.
> 
> especially since the decompression is an option for the module tools,
> it should be an option for the kernel... 
> since it does add a dependency for the module tools (and one that you
> might not need; for example I disabled it just to remove a build
> requires)

By the way, I for one use busybox for initramfs stuff, since a long
time ago.  And it (still?) does not support decompression of kernel
modules, as of the latest (1.13) version...  I don't think I'm alone
using busybox this way, and it looks like decompression support
should be added to it first, and next to the kernel.. ;)

/mjt
