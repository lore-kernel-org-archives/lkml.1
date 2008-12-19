Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYLSMrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYLSMrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 07:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYLSMrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 07:47:23 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:52540 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYLSMrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 07:47:22 -0500
To: adobriyan@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 18/19] Define MODULE_SYSTEM_TABLE for mbp_nvidia_bl.o and applesmc.o
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200812092114.mB9LETsI027215@imap1.linux-foundation.org>
	<493F1C96.5070400@bitmath.org>
	<200812120305.mBC35vh8078366@www262.sakura.ne.jp>
	<20081212042503.GA14668@x200.localdomain>
	<200812122202.CBJ65627.JOLQVtOFFSFMHO@I-love.SAKURA.ne.jp>
In-Reply-To: <200812122202.CBJ65627.JOLQVtOFFSFMHO@I-love.SAKURA.ne.jp>
Message-Id: <200812192147.JCA00588.MOtJLQFFOVOSFH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 19 Dec 2008 21:47:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tetsuo Handa wrote:
> Alexey Dobriyan wrote:
> > > -MODULE_DEVICE_TABLE(dmi, applesmc_whitelist);
> > > +MODULE_SYSTEM_TABLE(dmi, applesmc_whitelist);
> > 
> > I sent patch which does "#define dmi_device_id dmi_system_id" and thus
> > avoids yet another wrapper.
> > 
> I see. I'll try your patch after it is merged (2.6.28-rc8-gitX or 2.6.28-rc9 ?).

It's 2.6.28-rc9 now, but your patch is not applied yet.
Did somebody catch the "#define dmi_device_id dmi_system_id" patch?

Thanks.
