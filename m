Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbZLPVfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbZLPVfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbZLPVfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:35:50 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:33121 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757907AbZLPVft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:35:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAMvhKEuuWOl3/2dsb2JhbACBS9RuhCsEgWM
Date: Wed, 16 Dec 2009 16:35:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: leonid.moiseichuk@nokia.com, Viktor.Rosendahl@nokia.com, tony@atomide.com,
       eero.tamminen@nokia.com
Cc: "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [RELEASE] LTTng 0.182 for Linux kernel 2.6.32
Message-ID: <20091216213546.GA5609@Krystal>
References: <20091204160633.GA29864@Krystal> <20091213194210.GA3149@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091213194210.GA3149@nokia.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:25:54 up  5:44,  4 users,  load average: 0.16, 0.15, 0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I just released LTTng 0.182 for mainline kernel 2.6.32. It fixes ppc440
build and, more importantly, adds full support for ARM omap3 to the
trace clock:

- Power management support (suspend/resume, idle)
- DVFS support

Basically, the infrastructure is based on the 32k timer as external
time source, but uses the ccnt register to read the time base quickly at
each event. The trace clock is responsible for extending the 32-bit
counter to 64-bit, and for resynchronizing it on the 32k clock when
necessary.

I did all development and testing of the omap3 features on top of a
linux-omap-2.6 2.6.32-rc8 kernel and then reintegrated the patches in
the main LTTng tree. I only build-tested the port to main LTTng tree.

I should put the linux-omap-2.6-lttng tree online shortly, along with
the corresponding patchset.

Feedback is welcome !

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
