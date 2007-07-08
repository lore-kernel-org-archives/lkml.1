Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbXGHMfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbXGHMfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbXGHMfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 08:35:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37564 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbXGHMfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 08:35:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4690DA1B.3010901@s5r6.in-berlin.de>
Date: Sun, 08 Jul 2007 14:35:39 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: DervishD <lkml@dervishd.net>
CC: Linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: cdparanoia not setting count and/or reply_len properly
References: <20070708103928.GA20349@DervishD>
In-Reply-To: <20070708103928.GA20349@DervishD>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

DervishD wrote at lkml:
>     Hi all :)
> 
>     I know, this has been treated on the list before (year 2005) but
> without any real solution I'm aware of.
> 
>     I'm running kernel 2.6.20.14, and I have an ATAPI DVD writer that I
> use with an IDE-to-USB adapter, so it appears as an SCSI drive to the
> kernel.
> 
>     Anytime I rip anything with it, the log fills with the same message:
> some numbers about a certain number of bytes and the old friend message
> that I've put in the subject.
> 
>     I assume that the warning makes sense, but the fact is that my log
> is full with the same message, the ripping is correct (so cdparanoia is
> working OK WRT ripping) and if weren't for the printk_ratelimit, the
> system will freeze.
> 
>     I don't know if cdparanoia should be fixed, but certainly the
> warning could be issued only if CONFIG_SCSI_VERBOSE is set. This way you
> will have the message if something goes wrong and you want more info,
> but in cases where the warning is harmless your log will be clean...
> 
>     Anyway, this message is not for make suggestions, but for asking for
> information: why is this warning happening? naugthy cdparanoia? naughty
> kernel? I'm a bit confused and I want to use my external DVD drive for
> ripping from time to time, to "exercise" it...
> 
>     Thanks a lot in advance :)
> 
>     Raúl Núñez de Arenas Coronado
> 

This question is better asked at lsml.  (Therefore I'm quoting in full.)
-- 
Stefan Richter
-=====-=-=== -=== -=---
http://arcgraph.de/sr/
