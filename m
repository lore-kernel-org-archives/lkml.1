Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZGOPZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZGOPZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbZGOPZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:25:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53782 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbZGOPZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:25:24 -0400
Date: Wed, 15 Jul 2009 02:24:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com
Subject: Re: 2.6.31-rc1: zaurus suspend regressing
Message-ID: <20090715002445.GB2360@ucw.cz>
References: <20090704024416.GA1345@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090704024416.GA1345@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-07-04 04:44:16, Pavel Machek wrote:
> Hi!
> 
> In 2.6.30, spitz suspended with PSPR fix + charging disabled.
> 
> In 2.6.31-rc1, PSPR fix is in, but suspend does not work, not even
> with charging disabled.
> 
> Any ideas?

Tried -rc2-git, still broken. Even pm-test=devices killed the machine,
so I hope it is the IDE problem that should be fixed in -rc3.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
