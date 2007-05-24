Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbXEXWb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbXEXWb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbXEXWbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:31:19 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:39601 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbXEXWbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:31:17 -0400
Date: Fri, 25 May 2007 00:30:47 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Romano Giannetti <romano.giannetti@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk
Message-ID: <20070524223047.GA14641@linuxtv.org>
References: <20070521212522.GL3429@sequoia.sous-sol.org> <1179870110.16656.2.camel@localhost> <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> <1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost> <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org> <1180037649.15241.6.camel@localhost> <20070524140154.c8e93d69.akpm@linux-foundation.org> <20070524211237.GC1372@uranus.ravnborg.org> <1180043514.15241.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180043514.15241.31.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 87.162.100.226
Subject: Re: Long delay in resume from RAM (Was Re: [patch 00/69] -stablereview)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 11:51:53PM +0200, Romano Giannetti wrote:
> On Thu, 2007-05-24 at 23:12 +0200, Sam Ravnborg wrote:
> 
> > 
> > I really cannot see why it makes a difference.
> > If you use += (and :=) make will resolve EXTRA_CFLAGS when it see it.
> > Whereas with = make will resolve it only when actually referenced.
> > 
> > But the way we use EXTRA_CFLAGS it should not matter.
> > If the fix above really helps nfs I need to take a closer look tomorrow.
> 
> No, you're right, it doesn't help. What could help is a form of saying
> to make "add this EXTRA_CFLAGS  to whatever is specified in the command
> line". No idea if it exists.

The GNU make manual says:

"To append more text to a variable defined on the command line, use:

     override VARIABLE += MORE TEXT
"


HTH,
Johannes
