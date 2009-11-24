Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbZKXMQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbZKXMQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 07:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932227AbZKXMQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 07:16:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40332 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbZKXMQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 07:16:39 -0500
Date: Tue, 24 Nov 2009 12:57:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Null suspend/resume functions
Message-ID: <20091124115733.GB1397@ucw.cz>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com> <20091109105858.GB1245@sirena.org.uk> <20091109133136.GC1245@sirena.org.uk> <20091116153000.GB29479@sirena.org.uk> <20091117115236.GB1376@ucw.cz> <20091117124125.GD823@rakim.wolfsonmicro.main> <20091118160908.GD20887@elf.ucw.cz> <20091119112102.GF9763@rakim.wolfsonmicro.main> <20091121234509.GC1411@ucw.cz> <20091123110236.GB24326@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123110236.GB24326@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So you place a comment there; it should be there anyway. Having nop
> > during suspend/resume *is* unusual, and it should raise red flags.
> 
> This isn't a good assumption here.  Remember that this is for runtime PM
> so if we're getting as far as these calls then the driver has already
> told the core that it is idle, which probably means that the hardware is
> already quieseced.  For a lot of hardware that will mean that the

Ok, I did not realize we were talking runtime pm here.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
