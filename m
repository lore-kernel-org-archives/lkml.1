Return-Path: <linux-kernel-owner+w=401wt.eu-S1764939AbYEHPDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764939AbYEHPDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762391AbYEHPD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:03:29 -0400
Received: from 1wt.eu ([62.212.114.60]:4202 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760746AbYEHPD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:03:27 -0400
Date: Thu, 8 May 2008 16:59:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       St?phane ANCELOT <sancelot@free.fr>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>, YSadgat1@gcte.com,
       linux-os@analogic.com, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux IDE <linux-ide@vger.kernel.org>, Jeff Woods <jeff@jeffwoods.us>
Subject: Re: Compact Flash Question
Message-ID: <20080508145943.GT8474@1wt.eu>
References: <48215673.3060201@wpkg.org> <e2e108260805070044v42f596bbj39c5b52b6f0a096@mail.gmail.com> <48216039.3070001@wpkg.org> <4821A12F.2020800@aitel.hist.no> <4821C462.2000108@free.fr> <e2e108260805070946t63f35e36q6960bdff11fecd8c@mail.gmail.com> <20080508142714.GD6957@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508142714.GD6957@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 10:27:14AM -0400, Lennart Sorensen wrote:
> On Wed, May 07, 2008 at 06:46:25PM +0200, Bart Van Assche wrote:
> > Silicon Systems CompactFlashes are the among the most reliable
> > CompactFlashes I have used in embedded devices. See also
> > http://www.siliconsystems.com/silicondrive/whitepapers/SSWP03-Endurance-R.pdf
> > for a whitepaper that explains their wear leveling and error
> > correction algorithms. Furthermore, Silicon Systems has a technology
> > called SiSMART that allows to monitor by how far the CompactFlash is
> > worn out, such that it can be monitored whether or not it is time to
> > replace the CompactFlash. (Note: I am not affiliated in any way to
> > Silicon Systems.)
> 
> We too have switched to Silicon Systems and are very happy with them.
> And even industrial temperature versions are hardly expensive.  They may
> cost more than you pay for a generic slow piece of junk at a retail
> store, but you are getting a better card.

Interestingly, we once got a bunch of those and had a lot of problems
with them. Typically unbootable systems. We finally noticed that there
was a real corruption problem, because 3 MD5s of the kernel in a row
returned 3 different values. Our provider assured us that he never heard
about that, and insisted that we try again on a new batch. We have had
no trouble since. I guess we really got a bad batch. At least it was
noticeable early in the deployment process (the worst ones being a few
days after installation). However, we never had any problem with PQI
industrial.

> Len Sorensen

Willy

