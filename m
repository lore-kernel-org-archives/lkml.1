Return-Path: <linux-kernel-owner+w=401wt.eu-S933461AbXCJPSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbXCJPSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 10:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933464AbXCJPSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 10:18:17 -0500
Received: from mx1.suse.de ([195.135.220.2]:38050 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933461AbXCJPSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 10:18:16 -0500
From: Andreas Schwab <schwab@suse.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>, Valdis.Kletnieks@vt.edu,
       Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
References: <1173419792.32234.131.camel@localhost.localdomain>
	<1173481052.32234.137.camel@localhost.localdomain>
	<200703100403.l2A4355v008616@turing-police.cc.vt.edu>
	<1173503968.3104.65.camel@nigel.suspend2.net>
	<Pine.LNX.4.61.0703101452240.8799@yvahk01.tjqt.qr>
X-Yow: I'm having an emotional outburst!!
Date: Sat, 10 Mar 2007 16:18:10 +0100
In-Reply-To: <Pine.LNX.4.61.0703101452240.8799@yvahk01.tjqt.qr> (Jan
	Engelhardt's message of "Sat, 10 Mar 2007 15:01:32 +0100 (MET)")
Message-ID: <jeslcdktzh.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@linux01.gwdg.de> writes:

> So in case they _ARE_ compatible, we get the compile error, as far as I
> can see it. There's a ! too much in the !!_builtin line.

The error case is when the types are compatible.  That means that the
argument is in fact _not_ an array.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
