Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbYB1Bc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbYB1Bc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYB1Bcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:32:51 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2468 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbYB1Bcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:32:50 -0500
Date: Wed, 27 Feb 2008 20:15:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>,
       Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Jeff Garzik <jgarzik@pobox.com>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the bcm43xx driver breakage in 2.6.24/25.
Message-ID: <20080228011515.GH3078@tuxdriver.com>
References: <47C01D03.9030601@gmail.com> <47C19ABA.4040904@lwfinger.net> <20080227201550.GG3078@tuxdriver.com> <200802272258.33888.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802272258.33888.mb@bu3sch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 10:58:33PM +0100, Michael Buesch wrote:
> On Wednesday 27 February 2008 21:15:50 John W. Linville wrote:
> > On Sun, Feb 24, 2008 at 09:26:34AM -0700, Larry Finger wrote:
> > 
> > > I have reviewed the above patches and tested them with what I believe to be 
> > > most combinations. Everything worked and corrected the unintended 
> > > consequence of breaking bcm43xx when b44 is included. I agree that these 
> > > patches belong in 2.6.25 and stable (2.6.24). Of course, the problem goes 
> > > away in 2.6.26.
> > 
> > I can't say I really like Alexey's patches, but I guess they are OK.
> > I think I like the "b43_pci_bridge as a module" option a little better,
> > but as Michael illustrated there are problems with that approach too.
> 
> Well, I do like  "b43_pci_bridge as a module" more than this inter-dependency
> crap. Yeah, I don't like "b43_pci_bridge as a module" a lot, but certainly
> more than Alexey's patch.

Patches welcome... :-)

-- 
John W. Linville
linville@tuxdriver.com
