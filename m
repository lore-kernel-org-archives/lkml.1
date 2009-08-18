Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbZHRQzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbZHRQzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759429AbZHRQzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:55:33 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:47872 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759460AbZHRQza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=LIds5U9Vp7BnOmJz/9dd3pT6xVLwAoqO5jqJ4HgVeRyrIRbZRk83u201CS+cfcXw8Q
         wi3FtgAI+7yPz7qaVUoVYuRl3Eff37TuH3UPCr+CQ+DE1exqfNyuM9zNTWFpwcEJ+vvD
         ++ZPMnBCATRcAiWNBvfSykdSY72/ZQkOZmpiE=
Date: Tue, 18 Aug 2009 19:57:01 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v3] ASoC: OMAP: Enhance OMAP1510 DMA progress
 software counter
Message-Id: <20090818195701.6f260d33.jhnikula@gmail.com>
In-Reply-To: <20090818134540.GB24620@sirena.org.uk>
References: <200908101050.08074.jkrzyszt@tis.icnet.pl>
	<200908110107.11485.jkrzyszt@tis.icnet.pl>
	<200908112144.30731.jkrzyszt@tis.icnet.pl>
	<20090817122605.0b240ea7.jhnikula@gmail.com>
	<20090817100313.GA5756@rakim.wolfsonmicro.main>
	<4A8AAFAD.9050705@tis.icnet.pl>
	<20090818134540.GB24620@sirena.org.uk>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 14:45:41 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Tue, Aug 18, 2009 at 03:42:05PM +0200, Janusz Krzysztofik wrote:
> 
> > And now, how is the patch 1/3 supposed to get into the mainline? Whom  
> > should I ping from time to time to get it integrated? If not then, as  
> > you know for sure, applying patch 2/3 whithout 1/3 will result in ASoC  
> > support for OMAP1510 broken.
> 
> Normally the OMAP tree, though that's possibly a bit tricky due to the
> ARM tree closing early.  If Tony's OK with merging via the ALSA tree we
> could also apply the ARM patch there?

I would say that it's better to keep in Tony's hand since otherwise
there can be risk for DMA code being out-of-sync as there are quite
frequent other PM, OMAP4, errata, etc. patches coming into it.

Of course it means that OMAP1510 audio is broken until the patch 1/3 is
merged but probably patch can be merged as a fix if merge window is
missed.


-- 
Jarkko
