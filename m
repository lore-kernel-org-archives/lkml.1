Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbXEWSn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbXEWSn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbXEWSnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:43:52 -0400
Received: from smtp27.orange.fr ([80.12.242.95]:30438 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880AbXEWSnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:43:51 -0400
X-ME-UUID: 20070523184349929.E2F761C000A9@mwinf2707.orange.fr
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
From: Xavier Bestel <xavier.bestel@free.fr>
To: Ian Romanick <idr@us.ibm.com>
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
In-Reply-To: <4654867B.1060509@us.ibm.com>
References: <464F57DD.2000309@tmr.com> <46538AB8.8030009@tmr.com>
	 <200705241036.45179.kernel@kolivas.org>
	 <200705230723.42400.mgd@technosis.de>
	 <1179907115.7699.271.camel@frg-rhel40-em64t-04>
	 <4654867B.1060509@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Wed, 23 May 2007 20:43:46 +0200
Message-Id: <1179945826.31404.3.camel@bip.parateam.prv>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 23 mai 2007 à 11:22 -0700, Ian Romanick a écrit :
> > I think some people forget that X11 has its own scheduler for graphics
> > operations.
> 
> And in the direct-rendering case, this scheduler is not used for OpenGL.
>  The client-side driver submits rendering commands directly to its
> kernel module.  It is possible that some kernel modules perform some
> sort of scheduling, but none of the open-source drivers implement such a
> thing.

True, but glxgears isn't a pure DRI app: it calls XNextEvent() each time
it refreshes its window (which is quite often).

	Xav


