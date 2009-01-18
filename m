Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbZARVSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbZARVSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 16:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbZARVSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 16:18:07 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:53547 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbZARVSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 16:18:05 -0500
Date: Sun, 18 Jan 2009 22:18:03 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Arjan van de Ven <arjan@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
In-Reply-To: <49739BFA.4030609@msgid.tls.msk.ru>
Message-ID: <alpine.LSU.2.00.0901182217320.30423@fbirervta.pbzchgretzou.qr>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <20080226112840.GA29465@uranus.ravnborg.org> <alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr> <20081226194833.GA8306@uranus.ravnborg.org> <alpine.LSU.2.00.0812262049040.12031@fbirervta.pbzchgretzou.qr>
 <20090118210416.GE2978@uranus.ravnborg.org> <20090118130908.390eb07b@infradead.org> <49739BFA.4030609@msgid.tls.msk.ru>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2009-01-18 22:15, Michael Tokarev wrote:
>Arjan van de Ven wrote:
>> On Sun, 18 Jan 2009 22:04:16 +0100
>> Sam Ravnborg <sam@ravnborg.org> wrote:
>[]
>>> Can I ask you to redo this patch.
>>> I want a way to swith off compression, but it should default be
>>> enable. So if KBUILD_MODULE_NOCOMPRESS is undefined we will compress
>>> the modules when we install them.
>> 
>> especially since the decompression is an option for the module tools,
>> it should be an option for the kernel... 
>> since it does add a dependency for the module tools (and one that you
>> might not need; for example I disabled it just to remove a build
>> requires)
>
>By the way, I for one use busybox for initramfs stuff, since a long
>time ago.  And it (still?) does not support decompression of kernel
>modules, as of the latest (1.13) version...  I don't think I'm alone
>using busybox this way, and it looks like decompression support
>should be added to it first, and next to the kernel.. ;)

If we went by that metric, the kernel would still be in its infancy.
