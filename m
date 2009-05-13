Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZEMGge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZEMGge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZEMGgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:36:24 -0400
Received: from rankki.sonarnerd.net ([83.145.240.118]:31816 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbZEMGgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:36:24 -0400
Message-ID: <4A0A6A67.9010205@sonarnerd.net>
Date: Wed, 13 May 2009 09:36:23 +0300
From: Jussi Laako <jussi@sonarnerd.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       James Courtier-Dutton <James@superbug.co.uk>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       d.faggioli@sssup.it
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net>	 <1232954745.4863.4.camel@laptop>  <4A07E044.8040807@sonarnerd.net> <1242107859.11251.301.camel@twins> <4A094707.5040307@sonarnerd.net> <4A099670.5060902@nortel.com> <4A09A525.4080107@sonarnerd.net> <4A09AB2E.8030002@nortel.com> <4A09B7A1.2060706@sonarnerd.net> <4A0A0069.4090502@nortel.com>
In-Reply-To: <4A0A0069.4090502@nortel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Really?  You can call pthread_attr_setschedpolicy() with a policy of
> SCHED_MM?  On my copy of glibc 2.8 it explicitly checks for
> FIFO/RR/OTHER and anything else is rejected.

My copy of 2.9 has that fixed (original one is still broken), because
that's also broken for SCHED_IDLE and SCHED_BATCH which have been in the
kernel for a while already.

I'm not sure, but I think pthread_setschedparam() and
sched_setscheduler() didn't need fixing.


	- Jussi
