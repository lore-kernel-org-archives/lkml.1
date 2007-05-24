Return-Path: <linux-kernel-owner+w=401wt.eu-S1751053AbXEXUWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053AbXEXUWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXEXUVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:21:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:32586 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbXEXUVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ijvdq180knHa2kqncpa5RLRMz+VW6BvcDrMi4uVN1fwXEHTXeJ4pbHNhoQ7FPnDrIcPB9D2Mrfog2CNcqEPG2odR31D5bYv5feD6HPP5Z45fZjpZKiQZ5Pby8X/mgpYbLvStVJVwb3X/ToiJUArxOAKJadgnJppA5pqWYAS0p7o=
Subject: Re: Long delay in resume from RAM (Was Re: [patch 00/69]
	-stablereview)
From: Romano Giannetti <romano.giannetti@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <alpine.LFD.0.98.0705240851300.26602@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>
	 <4652070D.3090509@redhat.com>
	 <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
	 <20070521212522.GL3429@sequoia.sous-sol.org>
	 <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
	 <1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost>
	 <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org>
	 <alpine.LFD.0.98.0705240851300.26602@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 24 May 2007 22:21:41 +0200
Message-Id: <1180038102.15241.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 08:52 -0700, Linus Torvalds wrote:
> 
> On Thu, 24 May 2007, Linus Torvalds wrote:
> > 
> > Ok. That was probably true even before you added the suspend ordering 
> > patch.
> 
> Oh, no it apparently wasn't. I missed your other email that said
> 
>    "So, I tried to suspend without any card in the pcmcia slot. Guess what?
>     I extracted the card and the system did not suspend. Just stopped dead."
> 
> so apparently the patch actually did matter for you. Can you double-check 
> and confirm?
> 

Well, I've made a bit of a mess. The setup that has not the delay when
the card is out is a plain 2.6.21.2 (without suspend ordering). 

The lockup ocurred on a 2.6.21.1 WITH the suspend ordering patch, but
was just one time, after I plugged and unplugged the card several time.
Could not reproduce it, however. Puzzled.

Romano 
 

