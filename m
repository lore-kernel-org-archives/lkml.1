Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbXFAPdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbXFAPdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 11:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760464AbXFAPdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 11:33:24 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760420AbXFAPdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 11:33:24 -0400
Date: Fri, 1 Jun 2007 08:31:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "S.?a?lar Onur" <caglar@pardus.org.tr>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com
Subject: Re: [patch] CFS scheduler, -v14
In-Reply-To: <200706011635.02774.caglar@pardus.org.tr>
Message-ID: <alpine.LFD.0.98.0706010829041.3957@woody.linux-foundation.org>
References: <20070523120616.GA23407@elte.hu> <200705261758.26956.caglar@pardus.org.tr>
 <200706011635.02774.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, S.?a?lar Onur wrote:
> 
> Seems like this piece of hardware is dieing [For a while my laptop starts to 
> poweroff suddenly without any log/error etc] and i think all these problems 
> caused by this. Or at least/ for me/ this laptop (sony vaio fs-215b) is not a 
> stable test bed for this kind of human involved testings.

Has it been hot where you are lately? Is your fan working? 

Hardware that acts up under load is quite often thermal-related, 
especially if it starts happening during summer and didn't happen before 
that... ESPECIALLY the kinds of behaviours you see: the "sudden power-off" 
is the normal behaviour for a CPU that trips a critial overheating point, 
and the slowdown is also one normal response to overheating (CPU 
throttling).

		Linus
