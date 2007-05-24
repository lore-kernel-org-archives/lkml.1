Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbXEXVgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbXEXVgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbXEXVgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:36:32 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:35717 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbXEXVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C+E2/VFM3/IWF7ZD1enbS04J12fkTOAI/b8FnhgI4FKtpn1uwXeEsUpvE/fh44lxIJKoyQMX1s1ma4Fl0GYl4O2+y7XJigV58dEhVjTV29ZXGrpBYC300GXFtHRxAUwvM4/l9IebYEP9Wn0eZGSPYKuP43KbbA+29grVnzBsKFo=
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
In-Reply-To: <alpine.LFD.0.98.0705241334110.26602@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>
	 <4652070D.3090509@redhat.com>
	 <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
	 <20070521212522.GL3429@sequoia.sous-sol.org>
	 <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
	 <1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost>
	 <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org>
	 <alpine.LFD.0.98.0705240851300.26602@woody.linux-foundation.org>
	 <1180038102.15241.12.camel@localhost>
	 <alpine.LFD.0.98.0705241332100.26602@woody.linux-foundation.org>
	 <alpine.LFD.0.98.0705241334110.26602@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 24 May 2007 23:36:10 +0200
Message-Id: <1180042570.15241.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 13:35 -0700, Linus Torvalds wrote:
> 
> On Thu, 24 May 2007, Linus Torvalds wrote:
> > 
> > Occasional lockups on resume is probably a separate issue, and it might 
> > well be a race, or even just firmware timing bugs.
> 
> Btw, to solve the 60-second timeout problem, do you actually _need_ to 
> have CONFIG_PCMCIA_LOAD_CIS enabled for those cards to work for you? Quite 
> likely that's the "firmware" that screws up for you, and it's also not 
> totally unlikely that you don't even need it.

I could try to undefine it. As a fast try, I simply removed the .cis
file, and the card do not work (complains it can't find cis file). I do
not remember where, but I read that I need this file --- I think I found
it mentioned in the cardmgr->pccardctl conversion HOWTO. 

Romano 


