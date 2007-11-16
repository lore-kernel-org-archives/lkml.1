Return-Path: <linux-kernel-owner+w=401wt.eu-S1764894AbXKPMyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764894AbXKPMyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 07:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbXKPMyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 07:54:05 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:4117 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbXKPMyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 07:54:04 -0500
Date: Fri, 16 Nov 2007 13:54:00 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
In-Reply-To: <20071116054126.GA28606@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0711161337380.1817@scrub.home>
References: <11947274091127-git-send-email-sam@ravnborg.org>
 <Pine.LNX.4.64.0711142116500.1818@scrub.home> <20071114220840.GB10920@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711151616330.1817@scrub.home> <20071115192555.GD23914@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711152036430.1817@scrub.home> <20071115204520.GA24851@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711152158310.1817@scrub.home> <20071115220640.GA25265@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711160205340.1817@scrub.home> <20071116054126.GA28606@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 16 Nov 2007, Sam Ravnborg wrote:

> 1) make all*config, randconfig, defconfig is broken on 64-bit boxes

With your approach you made it impossible to set 64BIT from all*.config,
which is the proper way to set the defaults.

> 2) A pure code refactoring patch is reverted for no obvious reason

It was done for the wrong reasons, otherwise the warning before it should 
have been included as well and then the function could have been reused 
for the "# ... is not set" case as well.

> 3) Behavioral changes are not documented:
>    - 32-bit/64-bit can only be selected in config is you specify ARCH=x86

Which is now the default and thus it behaves more like other archs.

>    - ARCH= takes precedence over kernel config for a configured kernel

What point is there in being able to specify ARCH=x86_64 and then still 
produce a 32bit kernel?

> 4) The changelogs miss title on reverted patches

Seriously?

bye, Roman
