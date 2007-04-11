Return-Path: <linux-kernel-owner+w=401wt.eu-S1030484AbXDKFzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030484AbXDKFzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 01:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030816AbXDKFzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 01:55:11 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55905 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030484AbXDKFzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 01:55:10 -0400
X-Originating-Ip: 74.109.98.130
Date: Wed, 11 Apr 2007 01:52:39 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Adrian Bunk <bunk@stusta.de>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/30] Use menuconfig objects
In-Reply-To: <20070410231934.GA10141@stusta.de>
Message-ID: <Pine.LNX.4.64.0704110151040.7851@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
 <461C09D6.40805@s5r6.in-berlin.de> <Pine.LNX.4.61.0704110006320.32056@yvahk01.tjqt.qr>
 <20070410231934.GA10141@stusta.de>
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

On Wed, 11 Apr 2007, Adrian Bunk wrote:

> On Wed, Apr 11, 2007 at 12:09:01AM +0200, Jan Engelhardt wrote:
> >
> > On Apr 11 2007 00:04, Stefan Richter wrote:
> > >
> > >[...] I tried one of the patches
> > >  - with make xconfig: OK
> > >  - with make gconfig: OK
> > >  - with make menuconfig: less so, because:
> > >When one switches a menuconfig _on_, one might miss that there are
> > >subsequent options to configure.  (Although the availability of further
> > >options is indicated by the '--->' suffix to the menu title.)
> >
> > The kconfig files had some menuconfigs for some time
> > (CONFIG_EMBEDDED to be one). I do not think these menu entry types
> > are unknown.
>
> And the EMBEDDED menu has the interesting property that it's not
> empty with CONFIG_EMBEDDED=n .

that entire "Embedded" submenu is a hideous mis-design, as selecting
it simply presents you with options you can now "*de-select*.  that is
*anything* but intuitive.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
