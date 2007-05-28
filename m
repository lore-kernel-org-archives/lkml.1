Return-Path: <linux-kernel-owner+w=401wt.eu-S1763527AbXE1UDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763527AbXE1UDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 16:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760556AbXE1UDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 16:03:35 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39337 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759958AbXE1UDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 16:03:34 -0400
Date: Mon, 28 May 2007 22:04:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: Indan Zupancic <indan@nul.nu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fix section mismatch warnings in mtrr
Message-ID: <20070528200434.GC31233@uranus.ravnborg.org>
References: <200705191443.27161.arvidjaar@mail.ru> <200705261802.08573.ak@suse.de> <20070527090542.GA18399@uranus.ravnborg.org> <200705271156.22098.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705271156.22098.ak@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 11:56:21AM +0200, Andi Kleen wrote:
> 
> > 
> > So section mismatch warnings are more about catching sloopy usage of __init than it is to
> > catch potential kernel oopesen. But the latter is a nice side effect that is appreciated.
> 
> My point was that I cannot recall a single real oops bug found by the compile
> time checking.
> 
> We had a few in the past, but since we poison init data after boot they all tended
> to be found quickly anyways.
It's far better to find the bugs during build time than during run-time.

> But the warnings just seem to require endless changes and bogus changes
> (randomly moving code which was actually ok because it only called 
> in the init case).
The main culprint is probarly that the warnings are so vocal.
Everyone see them for each kernel-build that touches one file.
And then everyone and their cousin try to fix them.

When we are down to a warning-free x86 build things will start to look different.
And I will do my to make us get there - as time permits.

	Sam
