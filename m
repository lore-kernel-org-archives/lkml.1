Return-Path: <linux-kernel-owner+w=401wt.eu-S1030293AbXBZPWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293AbXBZPWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030294AbXBZPWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:22:08 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:38767 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293AbXBZPWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:22:07 -0500
X-Originating-Ip: 74.109.98.130
Date: Mon, 26 Feb 2007 10:19:30 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: second thoughts about DEPRECATED and OBSOLETE maturity levels
In-Reply-To: <20070226140909.GA14131@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0702261019020.20358@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0702251650580.29271@CPE00045a9c397f-CM001225dbafb6>
 <20070226140909.GA14131@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Sam Ravnborg wrote:

> On Sun, Feb 25, 2007 at 05:07:24PM -0500, Robert P. J. Day wrote:
> >
> >   having championed the cause of adding those two code maturity levels
> > to init/Kconfig, i just realized that implementing them as simple
> > dependencies has a *really* annoying shortcoming.
> >
> >   in order to display that a kernel config feature is experimental,
> > developers have not only made that feature depend on EXPERIMENTAL, but
> > they've also had to *explicitly* add the trailer "(EXPERIMENTAL)" to
> > the prompt line in the Kconfig file, to make it visually obvious.
> >
> >   obviously, it would be *way* nicer if that trailer were produced on
> > the fly for any "EXPERIMENTAL" feature, just as it would be for
> > OBSOLETE or DEPRECATED (or any other maturity levels people can dream
> > up).
>
> I have envisioned that this tag could be added by Kconfig automatically for
> all symbols that are dependent on EXPERIMENTAL.
> To do so the new option syntax could be extended.
> So we had something like:
> config EXPERIMENTAL
> 	bool "Bla bla"
> 	option adddisplay=(EXPERIMENTAL)
>
> This would cause all symbols selected by EXPERIMENTAL to have
> the string "(EXPERIMENTAL)" added to the prompt when displayed.
>
> Same could be used for DEPRECATED and OBSOLETE.

yup, that makes much more sense than my original idea of just
introducing simple dependencies.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
