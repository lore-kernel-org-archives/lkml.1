Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZKVORr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZKVORr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 09:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZKVORq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 09:17:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56648 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbZKVORq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 09:17:46 -0500
Date: Sun, 22 Nov 2009 00:45:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Null suspend/resume functions
Message-ID: <20091121234509.GC1411@ucw.cz>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com> <20091109105858.GB1245@sirena.org.uk> <20091109133136.GC1245@sirena.org.uk> <20091116153000.GB29479@sirena.org.uk> <20091117115236.GB1376@ucw.cz> <20091117124125.GD823@rakim.wolfsonmicro.main> <20091118160908.GD20887@elf.ucw.cz> <20091119112102.GF9763@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119112102.GF9763@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-11-19 11:21:03, Mark Brown wrote:
> On Wed, Nov 18, 2009 at 05:09:08PM +0100, Pavel Machek wrote:
> > On Tue 2009-11-17 12:41:25, Mark Brown wrote:
> 
> > > The problem I have with that is that for most APIs noop functions are a
> > > big fat warning sign that something is going wrong and the API is being
> > > abused.  This then creates noise and code review problems in the driver
> > > code since you've got something that normally suggests a problem.
> 
> > That still sounds like poor reason to add tests to core. But return 0
> > function for that purpose should be ok (and should make code easy to
> > review, too).
> 
> What makes you believe that this is a poor reason?  The issue isn't that
> the driver code is complex, the issue is that it's noise in the driver
> which suggests that the driver isn't doing something it's supposed to
> do.

So you place a comment there; it should be there anyway. Having nop
during suspend/resume *is* unusual, and it should raise red flags.

Plus, if we allowed NULLs there, we'd not know if the driver does not
implement it because it is not neccessary, or because they don't care.
 
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
