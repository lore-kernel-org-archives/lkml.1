Return-Path: <linux-kernel-owner+w=401wt.eu-S1764793AbXETKQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764793AbXETKQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 06:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbXETKQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 06:16:20 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57944 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479AbXETKQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 06:16:20 -0400
Date: Sun, 20 May 2007 12:17:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: RFC: kconfig select warnings bogus?
Message-ID: <20070520101717.GA22091@uranus.ravnborg.org>
References: <20070519151523.GA26724@uranus.ravnborg.org> <20070519110944.2a52061e.akpm@linux-foundation.org> <20070519230537.GI6291@stusta.de> <20070519162239.1bcb03d6.akpm@linux-foundation.org> <20070520094033.GA9645@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520094033.GA9645@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 10:40:33AM +0100, Russell King wrote:
> 
> Do we really need an exhaustive set of configuration combinations to
> run through Kconfig to find possible missing symbols?  Or do we need a
> Kconfig lint to find them?
> 
> If we're going to make Kconfig warn on missing symbols only when they're
> attempted to be selected, you'll have to choose one of those two options.
> Choosing none is not an option.
The best solution would be to give kconfig full knowledge of all
Kconfig files. Then the "undefined symbol" is no longer a warning
but an error.

That would require a bit of kconfig surgery that we should do one day.
But giving kconfig full knowledge would gain a lot in several scenarios.
Turning the undefined symbol to an error is just one part of it.

	Sam
