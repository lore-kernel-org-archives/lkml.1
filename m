Return-Path: <linux-kernel-owner+w=401wt.eu-S1761776AbXEWIWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbXEWIWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 04:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbXEWIWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 04:22:41 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:57498
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbXEWIWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 04:22:40 -0400
Date: Wed, 23 May 2007 01:21:12 -0700
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Michael Gerdau <mgd@technosis.de>, Con Kolivas <kernel@kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>,
       Miguel Figueiredo <elmig@debianpt.org>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Message-ID: <20070523082112.GE4442@gnuppy.monkey.org>
References: <464F57DD.2000309@tmr.com> <46538AB8.8030009@tmr.com> <200705241036.45179.kernel@kolivas.org> <200705230723.42400.mgd@technosis.de> <1179907115.7699.271.camel@frg-rhel40-em64t-04>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179907115.7699.271.camel@frg-rhel40-em64t-04>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 09:58:35AM +0200, Xavier Bestel wrote:
> On Wed, 2007-05-23 at 07:23 +0200, Michael Gerdau wrote:
> > For me the huge difference you have for sd to the others increases the
> > likelyhood the glxgears benchmark does not measure scheduling of graphic
> > but something else.
> 
> I think some people forget that X11 has its own scheduler for graphics
> operations.

OpenGL is generally orthogonal to X11 or at least should be. But this could
vary with the implementation depending on how brain damaged the system is.

I'd expect the performance charateristics to be different depending on what
subsystem is being used.

bill

