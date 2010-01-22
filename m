Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029Ab0AVJfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0AVJfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449Ab0AVJfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:35:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab0AVJea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:34:30 -0500
Subject: Re: scheduler vs hardware? (was Re: another i7  (linux) bug?)
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Luca Zini <luca.zini@gmail.com>, aagaande@gmail.com, rdelcueto@hotmail.com,
       mingo@elte.hu, linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>
In-Reply-To: <1264152314.12530.8.camel@marge.simson.net>
References: <201001211258.23499.luca.zini@gmail.com>
	 <20100121215438.GK17684@ldl.fc.hp.com>
	 <1264144758.8074.22.camel@marge.simson.net>
	 <1264150272.4283.1361.camel@laptop>
	 <1264152314.12530.8.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 10:34:20 +0100
Message-ID: <1264152860.4283.1442.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 10:25 +0100, Mike Galbraith wrote:
> On Fri, 2010-01-22 at 09:51 +0100, Peter Zijlstra wrote:
> 
> > My laptop does:
> > 
> > 
> > # time nice -n 19 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null
> 
> > real    0m3.273s
> > user    0m3.217s
> > sys     0m0.022s
> > 
> > 
> > # time nice -n 0 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null
> 
> > real    0m1.121s
> > user    0m1.102s
> > sys     0m0.013s
> 
> I don't see any way that can be scheduler (knocks wood).  Could it be
> cpufreq?  IIRC there is or was an ignore nice gizmo in there.

That's a laptop with full desktop bloat, I'm sure either firefox or evo
farted, or both.

