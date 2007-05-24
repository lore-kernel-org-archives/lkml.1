Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbXEXWvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbXEXWvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXEXWvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:51:33 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbXEXWvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:51:32 -0400
Date: Thu, 24 May 2007 15:49:47 -0700 (PDT)
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
Subject: Re: Long delay in resume from RAM (Was Re: [patch 
 00/69]-stablereview)
In-Reply-To: <1180044888.15241.39.camel@localhost>
Message-ID: <alpine.LFD.0.98.0705241549130.26602@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>  <4652070D.3090509@redhat.com>
  <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org> 
 <20070521212522.GL3429@sequoia.sous-sol.org>  <1179870110.16656.2.camel@localhost>
  <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> 
 <1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost>
  <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org>
 <1180044888.15241.39.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Romano Giannetti wrote:
> 
> Another naive doubt I have is: in 2.6.17.13, with additional patches
> http://zeus2.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d834c16516d1ebec4766fc58c059bf01311e6045
> http://zeus2.kernel.org/git/?p=linux/kernel/git/brodo/pcmcia-fixes-2.6.git;a=commitdiff;h=f755c48254ce743a3d4c1fd6b136366c018ee5b2
> http://zeus2.kernel.org/git/?p=linux/kernel/git/brodo/pcmcia-fixes-2.6.git;a=commitdiff;h=e6248ff596dd15bce0be4d780c60f173389b11c3
> 
> (now in the mainline), it works. And it used the cis file too.

It really would be nice of you to just "git bisect" this, to see where it 
started having that 60-second delay..

		Linus
