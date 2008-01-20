Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbYATPEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbYATPEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 10:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYATPD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 10:03:56 -0500
Received: from 1wt.eu ([62.212.114.60]:1430 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbYATPDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 10:03:55 -0500
Date: Sun, 20 Jan 2008 15:37:37 +0100
From: Willy Tarreau <w@1wt.eu>
To: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc8-git does not boot on Geode LX
Message-ID: <20080120143737.GA9234@1wt.eu>
References: <20080120081442.GA12713@1wt.eu> <47934FC8.1030800@i4.informatik.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47934FC8.1030800@i4.informatik.rwth-aachen.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sun, Jan 20, 2008 at 02:42:32PM +0100, Arnd Hannemann wrote:
> Hi,
> 
> Willy Tarreau schrieb:
> > Hi,
> > 
> > I've just pulled latest -git and tried this morning in on one of my ALIX
> > mobos equipped with an AMD Geode LX800 + CS5536. HEAD is a7da60f41551*.
> 
> We boot 2.6.24-rc8 on these mainboards, which BIOS version do you use?

I don"t remember and am not at home right now. I had 1.1 in mind but I may
be wrong.

> > So I tried disabling PCI, MFGPT, etc... But no success yet.
> 
> Did you try to boot with nomfgpt?

no, because I did not know about this one. I will try.

> In my experiments disabling CONFIG_GEODE_MFGPT_TIMER won't be enough to
> boot 2.6.24-rc8 on a v0.98 bios or on a v0.99 bios with MFGPT workaround
> turned on in the bios menu.

OK, that's a useful info.

> Otherwise the system will hang in arch/x86/kernel/mfgpt_32.c while
> trying to detect MFGPT timers.
> To clearify, for us the following works:
> v0.99 bios, MFGPT workaround turned off in bios and
> CONFIG_GEODE_MFGPT_TIMER=n

OK thanks very much. I'll try this ASAP.

Cheers!
Willy

