Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYFPMah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYFPMah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYFPMaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:30:08 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:51704 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753167AbYFPMaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:30:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroEAH/0VUhMQW1O/2dsb2JhbACBW6tR
Date: Mon, 16 Jun 2008 08:30:03 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, tzanussi@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: Re: [PATCH 3/3] relay: Add buffer-only channels; useful for early
	logging.
Message-ID: <20080616123003.GC18561@Krystal>
References: <20080613041013.274ccb28@linux360.ro> <48521C19.6070001@cs.helsinki.fi> <20080613185414.306b4baa@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080613185414.306b4baa@linux360.ro>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:25:02 up 11 days, 17:06,  2 users,  load average: 0.13, 0.36,
	0.43
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> On Fri, 13 Jun 2008 10:04:57 +0300
> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Why do we need to change for_each_online_cpu to for_each_present_cpu?
> > I guess it's because we don't have all the CPUs online at early
> > boot?
> 
> Yes, that's true. Only one CPU is online at that early point.
> 
> > Wouldn't it then be better to implement CPU hotplug support
> > instead?
> 
> It's difficult for me to write such code, as I'm unable to test CPU
> hotplug; my machines are a Turion X2 laptop and a Athlon Barton desktop
> computer. So I can't turn off, or unplug in a software sense, one CPU core.
> Correct me if I'm wrong, but I don't see any way to do that in /sys/devices/system/cpu/
> 

See Documentation/cpu-hotplug.txt

If you need to "emulate" having many CPUs, Xen is always an option.

> But I suppose I could write a patch very carefully, and then submit to
> someone that can test this. Anyway, I'll look into this and try to
> understand the code without being able to test.
> 

Hrm, sounds like a bad idea... please try getting a test setup working,
it will save you a gazillion iterations and let you stress-test your
code.

Mathieu

> 
> 	Eduard
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
