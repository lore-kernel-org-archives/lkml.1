Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYIFVcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYIFVcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 17:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYIFVcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 17:32:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394AbYIFVcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 17:32:41 -0400
Date: Sat, 6 Sep 2008 14:32:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Alok Kataria <akataria@vmware.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809062318230.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809061430010.3117@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> 
 <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>  <20080904204305.GA29065@elte.hu> <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809062240170.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061356270.3117@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809062301520.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061411430.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062318230.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Sep 2008, Thomas Gleixner wrote:
> 
> I didn't know that sending a test patch which is admittetly not pretty
> is a capital crime nowadays.

The thing is, there's a pattern to this. And it has nothing to do with 
"test patch".

See commit fbb16e243887332dd5754e48ffe5b963378f3cd2, and then see what I 
had to do in ec0c15afb41fd9ad45b53468b60db50170e22346.

That wasn't a test patch, was it?

I don't want to continually see these patches that are simply adding more 
and more crap. I want to not have to clean up the end result afterwards.

			Linus
