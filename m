Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbYD3OnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbYD3OnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbYD3OnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:43:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46437 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbYD3OnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:43:13 -0400
Date: Wed, 30 Apr 2008 16:43:12 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Andres Salomon <dilinger@queued.net>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>,
       Roland McGrath <roland@redhat.com>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
In-Reply-To: <20080430063552.GA30509@uranus.ravnborg.org>
Message-ID: <alpine.LNX.1.10.0804301641580.5623@fbirervta.pbzchgretzou.qr>
References: <20080429183531.GB19652@uranus.ravnborg.org> <20080429172402.14d7d40b@ephemeral> <20080430063552.GA30509@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-04-30 08:35, Sam Ravnborg wrote:
>> 
>> 'newconfig' sounds to me like you're creating a new config; the exact
>> opposite of what it does.  I'd suggest 'listnewconfig' or some such thing.
>
>listnewconfig is better - will use that.

Mh, newconfig sounds like  make K=/dev/null oldconfig/defconfig

>> Sounds good, I highly prefer specifying the config via env variable
>> rather than embedded in the target (ie, 'make olpc_defconfig').
>I will try to come up with some simple algorithm to locate the file.
>I guess something like:
>
>a) Try in local dir with name supplied
>b) If filname does not start with '/' try in arch/$ARCH/configs/*
>c) If filname does not start with '/' try in arch/$ARCH/configs/*_defconfig

Scan ./ before arch/$ARCH/configs/

>If filename is prefixed .gz unpack it

 /proc/.gzconfig? :-D (scnr)

