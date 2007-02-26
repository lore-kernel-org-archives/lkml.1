Return-Path: <linux-kernel-owner+w=401wt.eu-S1030303AbXBZQf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030303AbXBZQf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbXBZQf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:35:26 -0500
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:45609 "EHLO
	outbound4-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456AbXBZQfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:35:24 -0500
X-BigFish: V
Message-ID: <45E30C3E.80006@am.sony.com>
Date: Mon, 26 Feb 2007 08:35:10 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Roman Zippel <zippel@linux-m68k.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?77+9?= <toralf.foerster@gmx.de>
Subject: Re: [PATCH] ps3: Introduce CONFIG_PS3_ADVANCED
References: <200702210946.27758.toralf.foerster@gmx.de> <Pine.LNX.4.62.0702211102000.340@pademelon.sonytel.be> <Pine.LNX.4.64.0702211238400.14457@scrub.home> <Pine.LNX.4.62.0702211322350.340@pademelon.sonytel.be> <Pine.LNX.4.64.0702220052020.14457@scrub.home> <Pine.LNX.4.62.0702221854520.25919@pademelon.sonytel.be> <Pine.LNX.4.64.0702232343330.14457@scrub.home> <Pine.LNX.4.62.0702261644310.5716@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0702261644310.5716@pademelon.sonytel.be>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2007 16:35:13.0611 (UTC) FILETIME=[16E7F1B0:01C759C4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> ps3: Introduce CONFIG_PS3_ADVANCED, as suggested by Roman Zippel, and use it to
> control questions about PS3 subsystems that may not be obvious for the casual
> user.
> 
> This gets rid of the following warning on non-powerpc platforms:
> | drivers/video/Kconfig:1604:warning: 'select' used by config symbol 'FB_PS3' refer to undefined symbol 'PS3_PS3AV'

Please apply, fixes build warning in 2.6.21-rc1.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

