Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbZKRQJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbZKRQJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbZKRQJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:09:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45599 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475AbZKRQJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:09:13 -0500
Date: Wed, 18 Nov 2009 17:09:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Magnus Damm <damm@opensource.se>, alsa-devel@alsa-project.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Null suspend/resume functions
Message-ID: <20091118160908.GD20887@elf.ucw.cz>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com>
 <20091109105858.GB1245@sirena.org.uk>
 <20091109133136.GC1245@sirena.org.uk>
 <20091116153000.GB29479@sirena.org.uk>
 <20091117115236.GB1376@ucw.cz>
 <20091117124125.GD823@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117124125.GD823@rakim.wolfsonmicro.main>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-11-17 12:41:25, Mark Brown wrote:
> On Tue, Nov 17, 2009 at 12:52:36PM +0100, Pavel Machek wrote:
> 
> > I believe that having few nop functions around the tree should not be
> > huge problem. If it is, you can introduce one shared top function into
> > the core...
> 
> The problem I have with that is that for most APIs noop functions are a
> big fat warning sign that something is going wrong and the API is being
> abused.  This then creates noise and code review problems in the driver
> code since you've got something that normally suggests a problem.

That still sounds like poor reason to add tests to core. But return 0
function for that purpose should be ok (and should make code easy to
review, too).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
