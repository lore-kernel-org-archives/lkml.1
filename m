Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYB0PGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYB0PGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYB0PGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:06:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59638 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYB0PGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:06:17 -0500
Date: Wed, 27 Feb 2008 16:06:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86] rdc321x: Kconfig options fixes for rdc321x
Message-ID: <20080227150604.GC21610@elte.hu>
References: <200802271136.42763.florian.fainelli@telecomint.eu> <20080227105307.GA21050@elte.hu> <200802271206.44493.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802271206.44493.florian.fainelli@telecomint.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Florian Fainelli <florian.fainelli@telecomint.eu> wrote:

> Hi Ingo,
> 
> Le mercredi 27 février 2008, Ingo Molnar a écrit :
> > these many special conditions in the Kconfig space are way too ugly.
> > (Also, i can see no reason why for example hibernation wouldnt be
> > possible on rdc321x, it's a pure software concept ...)
> 
> I would have thought an embedded device with only flash memory as rom 
> storage could not hibertnate.
> 
> Maybe we should turn all those special conditions into HAVE_FOO/BAR 
> instead ?

no. Just leave those things alone. Obviously, if you dont initiate 
hibernation it wont be done - and you dont have to build it in either. 
But there's no fundamental reason that it _couldnt_ work - if a suitable 
device was attached. Dont put such hardcoded dependencies into the 
kernel ...

	Ingo
