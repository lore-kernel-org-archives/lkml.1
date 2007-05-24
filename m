Return-Path: <linux-kernel-owner+w=401wt.eu-S1751231AbXEXPxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbXEXPxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbXEXPxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:53:41 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbXEXPxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:53:40 -0400
Date: Thu, 24 May 2007 08:52:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Romano Giannetti <romanol@upcomillas.es>
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
In-Reply-To: <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705240851300.26602@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>  <4652070D.3090509@redhat.com>
  <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org> 
 <20070521212522.GL3429@sequoia.sous-sol.org>  <1179870110.16656.2.camel@localhost>
  <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> 
 <1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost>
 <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 May 2007, Linus Torvalds wrote:
> 
> Ok. That was probably true even before you added the suspend ordering 
> patch.

Oh, no it apparently wasn't. I missed your other email that said

   "So, I tried to suspend without any card in the pcmcia slot. Guess what?
    I extracted the card and the system did not suspend. Just stopped dead."

so apparently the patch actually did matter for you. Can you double-check 
and confirm?

		Linus
