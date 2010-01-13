Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509Ab0AMMRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0AMMRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 07:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318Ab0AMMRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 07:17:34 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:33700 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0AMMRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:17:34 -0500
Date: Wed, 13 Jan 2010 07:16:49 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
       sameo@linux.intel.com, Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH] typo in kernel source (DEBUGFS)
In-Reply-To: <20100113115712.GA7398@faui49.informatik.uni-erlangen.de>
Message-ID: <alpine.LFD.2.00.1001130710120.878@localhost>
References: <20100113115712.GA7398@faui49.informatik.uni-erlangen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010, Christoph Egger wrote:

> Hi all!
>
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
>
> 	While working on this we detected a spelling error in
> drivers/mfd/ab3100-otp.c which can be corrected using the attached
> patch.
>
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.
>
> Regards
>
> 	Christoph Egger
>
> [0] http://vamos1.informatik.uni-erlangen.de/

  by the way, if you're rooting around in the drivers/mfd directory,
feel free to correct this obvious typo in twl-core.c:

...
#if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
        || defined(CONFIG_INPUT_TWL4030_PWBUTTON_MODULE)
                                          ^ missing "R"
...

  there's also the test of the non-existent
CONFIG_TWL4030_BCI_BATTERY variable in twl-core.c and, well, you get
the idea.

rday
--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
