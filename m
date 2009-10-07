Return-Path: <linux-kernel-owner+w=401wt.eu-S934115AbZJGI6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115AbZJGI6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933730AbZJGI6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:58:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43196 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933549AbZJGI6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:58:48 -0400
Date: Wed, 7 Oct 2009 10:58:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com
Subject: Re: spitz: add gpio button support (AK_INT and remote control
	description)
Message-ID: <20091007085806.GB28807@elf.ucw.cz>
References: <20091006074635.GA2775@ucw.cz> <1254829732.3546.35.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254829732.3546.35.camel@utx.utx.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-10-06 13:48:52, Stanislav Brabec wrote:
> Pavel Machek wrote:
> > I'm not sure what AK_INT is, nor what event it should
> > generate.
> 
> AK_INT: remote control detect

Thanks. So for now I'll do:

        /* This is for remote control support. Zaurus supports wired                  
           remote on headphones. */
        {
                .type   = EV_KEY,
                .code   = KEY_F13,
                .gpio   = SPITZ_GPIO_AK_INT,
                .desc   = "Wired remote (AK_INT)",
        },

..and leave it for proper driver to support nicely.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
