Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbXJ1Qfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbXJ1Qfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 12:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbXJ1Qff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:35:35 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:44394 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXJ1Qfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:35:34 -0400
Date: Sun, 28 Oct 2007 12:31:50 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Michael Buesch <mb@bu3sch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [2.6 patch] fix USB_OHCI_HCD_SSB dependencies
In-Reply-To: <4724B597.1070806@goop.org>
Message-ID: <Pine.LNX.4.64.0710281230430.4921@localhost.localdomain>
References: <20071027010647.GN30533@stusta.de> <20071027085748.GB3742@elte.hu>
 <20071027134556.GS30533@stusta.de> <4724B597.1070806@goop.org>
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
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Jeremy Fitzhardinge wrote:

> Adrian Bunk wrote:
> > On Sat, Oct 27, 2007 at 10:57:48AM +0200, Ingo Molnar wrote:
> >
> >> * Adrian Bunk <bunk@kernel.org> wrote:
> >>
> >>
> >>> -	depends on USB_OHCI_HCD && (SSB = y || SSB = CONFIG_USB_OHCI_HCD) && EXPERIMENTAL
> >>> +	depends on USB_OHCI_HCD && (SSB = y || SSB = USB_OHCI_HCD) && EXPERIMENTAL
> >>>
> >> oops, indeed ... my Kconfig fu needs strengthening. Does Kconfig warn
> >> somewhere if it sees an erroneous CONFIG_ token?
> >>
> >
> > No. IIRC Sam was working in getting warnings for such things, but
> > currently kconfig simply can't know whether it's a bug or OK.
>
> Are there any instances of CONFIG_CONFIG_X?  Doesn't seem like a
> terribly sensible name...

there used to be:

http://lists.linuxcoding.com/kernel/2006-q1/msg18685.html

but that was just the one, and it's gone now.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
