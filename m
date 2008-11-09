Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYKIV6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYKIV6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbYKIV6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:58:03 -0500
Received: from www.tglx.de ([62.245.132.106]:47361 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191AbYKIV6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:58:01 -0500
Date: Sun, 9 Nov 2008 22:57:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
cc: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, corsac@debian.org, elendil@planet.nl
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
In-Reply-To: <20081109214338.GB4385@ics.muni.cz>
Message-ID: <alpine.LFD.2.00.0811092256080.12263@localhost.localdomain>
References: <20081104173300.GF6134@ics.muni.cz> <20081109105159.GA5867@joi> <20081109113304.GE4353@ics.muni.cz> <200811091424.10943.rjw@sisk.pl> <20081109200918.GA4361@ics.muni.cz> <20081109122835.10f410fa@infradead.org> <20081109203432.GB4361@ics.muni.cz>
 <20081109132438.5d81cd74@infradead.org> <20081109214338.GB4385@ics.muni.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008, Lukas Hejtmanek wrote:
> On Sun, Nov 09, 2008 at 01:24:38PM -0800, Arjan van de Ven wrote:
> > it would be greatly appreciated if those that see this issue can test the
> > patch below (which is a combo patch of thomas' fixes, to make testing
> > easier) and confirm if this fixes the hangs.  If they do fix the issue we
> > don't need to disable anything and get better power savings as bonus as
> > well.
> 
> hmm, on the other hand, powertop application shows that C4 state is 51.5%
> residency and C0 is 47.3% residency. I have about 5% C0 residency and 95-98%
> C3 residency. Is this expected?

Hmm. I do not understand. Where from are the second numbers ? 

Can you please provide your .config ?

Thanks,

	tglx
