Return-Path: <linux-kernel-owner+w=401wt.eu-S965954AbYD1URT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965954AbYD1URT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933862AbYD1URH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:17:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:41558 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932829AbYD1URG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:17:06 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19BJN8Mn59BuNL1z23kswDjcBhoQ1+FKALoGg62DS
	fd9am/U3l77HTr
Date: Mon, 28 Apr 2008 22:17:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] video: fix SOC_CAMERA_MT9M001 build bug
In-Reply-To: <20080428201105.GD15840@elte.hu>
Message-ID: <Pine.LNX.4.64.0804282215470.11449@axis700.grange>
References: <20080428120032.GA23847@elte.hu> <Pine.LNX.4.64.0804281944100.10718@axis700.grange>
 <20080428193130.GC9907@elte.hu> <Pine.LNX.4.64.0804282138000.11449@axis700.grange>
 <20080428201105.GD15840@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Ingo Molnar wrote:

> 
> * Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > > as you can see it from the build log above, the compiler disagrees 
> > > with you on whether the driver depends on I2C. I'm just the 
> > > messenger :)
> > 
> > Very sorry, but I don't see it. What I see above, is that mt9m001 and 
> > mt9v022 cannot be compiled - as I said, _they_ need i2c. And I don't 
> > see a single line for soc_camera.c. SOC_CAMERA is a generic API, it 
> > shouldn't have any hardware dependencies at all. Whereas mt9v022 and 
> > mt9m001 are 2 specific i2c cameras.
> 
> sorry, you are right. Mind doing the right patch as you know this code 
> much better than i do?

Ok, will do, although, the fix is just to duplicate your patch and move it 
from under SOC_CAMERA to MT9V022 and MT9M001. Thanks for reporting.

Guennadi
---
Guennadi Liakhovetski
