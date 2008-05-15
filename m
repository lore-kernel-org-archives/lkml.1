Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbYEOWSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbYEOWSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 18:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYEOWSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 18:18:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:47810 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751790AbYEOWSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 18:18:07 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/nEls1K9Tnrur3NyX8c9BRIE78LUAH9a9nTE257Z
	rOJxFUiN+Z6VP0
Date: Fri, 16 May 2008 00:18:03 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Pascal =?iso-8859-1?Q?Br=FCckner?= <pascal_2001@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange C3/C4 sleep state behaviour
Message-ID: <20080515221803.GA17259@atjola.homenet>
References: <482CA6E4.1010807@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <482CA6E4.1010807@web.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.05.15 23:11:00 +0200, Pascal Brückner wrote:
> Hello!
>
> I'm recompiling my kernel recently to optimize the power usage of my
> laptop (IBM ThinkPad X31). So far, my most efficient kernel at the
> moment is a self-compiled 2.6.22 with phc patches for undervolting,
> suspend2/tuxonice and hrtimers patches to force HPET on my ICH4-M chipset.
>
> Because everyone says, that newer kernel revisions are much more energy
> efficient than my 2.6.22, i tried to compile one to reach at least the
> energy usage of my recent kernel.
> Sadly, this doesn't work because of only one issue:
> With activated wireless networking (atheros chipset with recent madwifi
> driver) i'm losing much energy due to the fact, that my cpu is
> significant more in C2 state than in C3/C4.

Do you have CONFIG_CPU_IDLE enabled? That made a huge difference for me.
Before that was available, _disabling_ CONFIG_NO_HZ also helped when
wifi was enabled (but IIRC made things worse with wifi disabled).

Björn
