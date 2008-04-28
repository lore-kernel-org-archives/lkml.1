Return-Path: <linux-kernel-owner+w=401wt.eu-S965215AbYD1UL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965215AbYD1UL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932239AbYD1ULS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:11:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37968 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765876AbYD1ULR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:11:17 -0400
Date: Mon, 28 Apr 2008 22:11:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] video: fix SOC_CAMERA_MT9M001 build bug
Message-ID: <20080428201105.GD15840@elte.hu>
References: <20080428120032.GA23847@elte.hu> <Pine.LNX.4.64.0804281944100.10718@axis700.grange> <20080428193130.GC9907@elte.hu> <Pine.LNX.4.64.0804282138000.11449@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804282138000.11449@axis700.grange>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> > as you can see it from the build log above, the compiler disagrees 
> > with you on whether the driver depends on I2C. I'm just the 
> > messenger :)
> 
> Very sorry, but I don't see it. What I see above, is that mt9m001 and 
> mt9v022 cannot be compiled - as I said, _they_ need i2c. And I don't 
> see a single line for soc_camera.c. SOC_CAMERA is a generic API, it 
> shouldn't have any hardware dependencies at all. Whereas mt9v022 and 
> mt9m001 are 2 specific i2c cameras.

sorry, you are right. Mind doing the right patch as you know this code 
much better than i do?

	Ingo
