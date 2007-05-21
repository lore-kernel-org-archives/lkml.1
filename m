Return-Path: <linux-kernel-owner+w=401wt.eu-S1764022AbXEUPK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764022AbXEUPK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759223AbXEUPKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:10:48 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52728 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266AbXEUPKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:10:47 -0400
Date: Mon, 21 May 2007 17:11:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-kernel@vger.kernel.org, Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH] x86: fix section mismatch warnings in mtrr
Message-ID: <20070521151139.GA1929@uranus.ravnborg.org>
References: <200705191443.27161.arvidjaar@mail.ru> <20070519133257.GB23370@uranus.ravnborg.org> <200705191555.49376.ak@suse.de> <4651A113.9020300@goop.org> <20070521134828.GA1394@uranus.ravnborg.org> <4651A427.4010600@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4651A427.4010600@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 02:52:39PM +0100, Jeremy Fitzhardinge wrote:
> Sam Ravnborg wrote:
> > There was another patch that removed the __init marker to _fix_ section mismatch errors.
> > I have lost the actual mail but I asked the submitter to send me a copy of
> > the configuration so I could take a closer look.
> > Obviously it was the wrong fix to remove the _init marker.
> 
> Hm, I think there were two overlapping patches to address the problem. 
> One removed the __init markers, and was a bit of a hack.  Mine
> restructured all the functions so that it was all done properly (ie,
> init called init; cpuinit called cpuinit).  Looks like both got applied.

OK, then all is good.

	Sam
