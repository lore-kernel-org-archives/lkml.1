Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbYECHkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbYECHkD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 03:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYECHjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 03:39:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:53532 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750771AbYECHjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 03:39:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Hgqlg3alHYp5lqMoPC/wOw3dB5vbMo4dHRj69Qk
	KBhrf/OitfrSCB
Subject: Re: Horrendous Audio Stutter - current git
From: Mike Galbraith <efault@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: Parag Warudkar <parag.warudkar@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200805030913.55124.elendil@planet.nl>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <82e4877d0805020521t696cc4fbu6ffd182f84ae1a2e@mail.gmail.com>
	 <1209731822.25271.4.camel@marge.simson.net>
	 <200805030913.55124.elendil@planet.nl>
Content-Type: text/plain
Date: Sat, 03 May 2008 09:39:48 +0200
Message-Id: <1209800388.14307.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-05-03 at 09:13 +0200, Frans Pop wrote:

> Based on Mike's mails I have quickly tried reverting the following two 
> commits to see if that would fix the GROUP_SCHED related regression, but I 
> still get a merge error with the second one in sched_fair.c:
> $ git revert 7ba2e74ab5
> $ git revert 8f1bc385cf
> 
> I don't feel comfortable solving the conflict myself as I'd have absolutely 
> no idea what I'd be doing and it all seems to require a lot of precision.
> 
> As other suggested patches don't seem ready for testing yet, I'll just wait 
> for further instructions :-)

You probably shouldn't bother.  GROUP_SCHED needs Peter's EEVDF help
regardless of whether 8f1bc385cf is playing a significant role or not.

	-Mike

