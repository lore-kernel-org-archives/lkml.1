Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbXEXUgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbXEXUgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXEXUgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:36:37 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbXEXUgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:36:36 -0400
Date: Thu, 24 May 2007 13:35:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Romano Giannetti <romano.giannetti@gmail.com>
cc: Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: Long delay in resume from RAM (Was Re: [patch 00/69]
 -stablereview)
In-Reply-To: <alpine.LFD.0.98.0705241332100.26602@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705241334110.26602@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>  <4652070D.3090509@redhat.com>
  <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org> 
 <20070521212522.GL3429@sequoia.sous-sol.org>  <1179870110.16656.2.camel@localhost>
  <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> 
 <1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost>
  <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org> 
 <alpine.LFD.0.98.0705240851300.26602@woody.linux-foundation.org>
 <1180038102.15241.12.camel@localhost>
 <alpine.LFD.0.98.0705241332100.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 May 2007, Linus Torvalds wrote:
> 
> Occasional lockups on resume is probably a separate issue, and it might 
> well be a race, or even just firmware timing bugs.

Btw, to solve the 60-second timeout problem, do you actually _need_ to 
have CONFIG_PCMCIA_LOAD_CIS enabled for those cards to work for you? Quite 
likely that's the "firmware" that screws up for you, and it's also not 
totally unlikely that you don't even need it.

			Linus
