Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYHSPXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYHSPXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYHSPXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:23:11 -0400
Received: from styx.suse.cz ([82.119.242.94]:43981 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752439AbYHSPXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:23:10 -0400
Date: Tue, 19 Aug 2008 17:23:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Aivils Stoss <aivils@latnet.lv>, stern@rowland.harvard.edu,
       lud <linux-usb@vger.kernel.org>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxconsole-dev@lists.sourceforge.net
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
In-Reply-To: <20080819081936.37fef673.rdunlap@xenotime.net>
Message-ID: <alpine.LNX.1.10.0808191721560.18058@jikos.suse.cz>
References: <200808080702.24969.aivils@latnet.lv> <200808181642.49489.aivils@latnet.lv> <20080818081432.782d9632.rdunlap@xenotime.net> <200808191527.06945.aivils@latnet.lv> <20080819081936.37fef673.rdunlap@xenotime.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, Randy Dunlap wrote:

> > 2.6.22-1-mepis-smp
> > Quite stable. Have oops sometime inside evdev. Support up to 16 
> > USB keyboards, where 4 hubs are plugged into PC and 4 keyboards on
> > each hub. Any hub cascade support only 4 keyboards, where 5th or more
> > is registered but don't send input events. Oops inside evdev , when
> > USB keyboard unplugged. No slow down even all USB keyboards does
> > not work properly. My be this one support more than 16 keyboards, but
> > i don't have PC USB ports enough.
> Has the evdev oops been reported and/or fixed? I think that we would 
> prefer to fix that soonish.

We haven't seen the respective oops yet, or have I missed it?

I'd bet it is fixed in newer kernels by patches that introduce proper 
locking into evdev code.

-- 
Jiri Kosina
SUSE Labs
