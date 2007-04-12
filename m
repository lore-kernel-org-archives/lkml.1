Return-Path: <linux-kernel-owner+w=401wt.eu-S2992561AbXDLPWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992561AbXDLPWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992565AbXDLPWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:22:42 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55106 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992561AbXDLPWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:22:41 -0400
X-Originating-Ip: 74.109.98.130
Date: Thu, 12 Apr 2007 11:21:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Carlo Florendo <subscribermail@gmail.com>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "menu" versus "menuconfig" -- they're *both* a bad idea
In-Reply-To: <461D84EB.7040207@gmail.com>
Message-ID: <Pine.LNX.4.64.0704121118390.24425@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0704110357200.9384@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0704111059190.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0704110509200.11343@CPE00045a9c397f-CM001225dbafb6>
 <461D84EB.7040207@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007, Carlo Florendo wrote:

> Robert P. J. Day wrote:
> >   (in short, if i, the builder, explicitly choose *not* to add a
> > certain feature to my build, i think i have every right to expect that
> > some other part of my configuration isn't quietly going to put some
> > sub-choice of that feature back in behind my back.)
>
> I agree with this.  However, if another feature actually depends on
> another explicitly unselected feature, there should at least be a
> warning prompt that such is the case.
>
> It probably would be hard though to track all dependencies.

i can't imagine this is a widespread problem in the tree -- i mean, we
keep using CONFIG_EMBEDDED as an example, and we mostly agree that
that's just a bad design, anyway.

but it should be obvious that, if you look at the Kconfig files, each
and every "select" directive has the potential to override a decision
you think you might have made elsewhere.

I'm just sayin'.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
