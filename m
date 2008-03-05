Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbYCENrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbYCENrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYCENrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:47:10 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50536 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYCENrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:47:09 -0500
Date: Wed, 5 Mar 2008 14:47:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080305134738.GC26199@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org> <20080303231033.GB15255@one.firstfloor.org> <20080304040048.GA31562@codemonkey.org.uk> <20080304071423.0e6b71c1@mjolnir.drzeus.cx> <20080304181924.70aaf8c1@mjolnir.drzeus.cx> <924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com> <20080305070201.0d16cd40@mjolnir.drzeus.cx> <20080305094023.6486ebdf@mjolnir.drzeus.cx> <20080305090304.GA10053@elf.ucw.cz> <20080305144205.7a9971bc@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305144205.7a9971bc@mjolnir.drzeus.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-05 14:42:05, Pierre Ossman wrote:
> On Wed, 5 Mar 2008 10:03:04 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > 
> > Actually, there are more uncertaininties. Suspecting some machines
> > seemed to produce noise whenever they were in low-power state. Not
> > with fluctuations: when I forced them to low-power, it just produced
> > steady beep.
> > 
> 
> Ouch. How do I quickly test that here?

Setting cpufreq to lowest frequency reproduced it for me, but I guess
notebooks are different.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
