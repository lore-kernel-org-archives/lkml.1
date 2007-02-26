Return-Path: <linux-kernel-owner+w=401wt.eu-S1030241AbXBZOI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241AbXBZOI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 09:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030260AbXBZOI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 09:08:56 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:55459 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030241AbXBZOIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 09:08:55 -0500
Date: Mon, 26 Feb 2007 15:09:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: second thoughts about DEPRECATED and OBSOLETE maturity levels
Message-ID: <20070226140909.GA14131@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0702251650580.29271@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702251650580.29271@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 05:07:24PM -0500, Robert P. J. Day wrote:
> 
>   having championed the cause of adding those two code maturity levels
> to init/Kconfig, i just realized that implementing them as simple
> dependencies has a *really* annoying shortcoming.
> 
>   in order to display that a kernel config feature is experimental,
> developers have not only made that feature depend on EXPERIMENTAL, but
> they've also had to *explicitly* add the trailer "(EXPERIMENTAL)" to
> the prompt line in the Kconfig file, to make it visually obvious.
> 
>   obviously, it would be *way* nicer if that trailer were produced on
> the fly for any "EXPERIMENTAL" feature, just as it would be for
> OBSOLETE or DEPRECATED (or any other maturity levels people can dream
> up).

I have envisioned that this tag could be added by Kconfig automatically for
all symbols that are dependent on EXPERIMENTAL.
To do so the new option syntax could be extended.
So we had something like:
config EXPERIMENTAL
	bool "Bla bla"
	option adddisplay=(EXPERIMENTAL)

This would cause all symbols selected by EXPERIMENTAL to have
the string "(EXPERIMENTAL)" added to the prompt when displayed.

Same could be used for DEPRECATED and OBSOLETE.

I have not looked into the feasability to implement this - other
Kconfig items needs to be fixed first.

	Sam
