Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbYB0SbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbYB0SbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYB0SbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:31:16 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50909 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbYB0SbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:31:16 -0500
Date: Wed, 27 Feb 2008 19:31:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080227183128.GA12411@uranus.ravnborg.org>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi> <20080225111707.GA7062@elte.hu> <20080225190241.GA23161@uranus.ravnborg.org> <20080226094451.GL9857@elte.hu> <20080226201442.GB32685@uranus.ravnborg.org> <20080226203053.GB14350@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226203053.GB14350@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> what would be really useful is an automatic Kconfig tree analysis, with 
> the printing out of too deep dependencies perhaps? Which might result in 
> the breaking down of too deep dependencies - to increase the coverage of 
> randconfig testing. Sometimes the number of "depends on" conditions are 
> mind-blowing.

If I get into kconfig hacking again I will try to look into fixing
kconfig so we can have all Kconfig files in one hirachy.
This would gives us useful information such as dependencies on
unknow symbols and the like.

Statistics as you describe could be relevant to find bad
Kconfig design but I see this much more as a check thing
for bad design than something to make it easier to reach
more configs with 100 randconfigs.

Anyway - this is just vapourware until someone starts
to hack on kconfig.

	Sam
