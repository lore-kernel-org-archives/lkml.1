Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbZHCWYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbZHCWYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZHCWYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:24:01 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:42295 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922AbZHCWYB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:24:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEALv+dkpMQWXi/2dsb2JhbACBUtFLhBgFhBk
Date: Mon, 3 Aug 2009 18:23:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [Regression] Hibernation failure on dual core Athlon 64
	(64-bit)
Message-ID: <20090803222359.GA3770@Krystal>
References: <200908032303.57859.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200908032303.57859.rjw@sisk.pl>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:22:38 up 156 days, 18:48,  3 users,  load average: 1.39, 1.10,
	0.95
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> Hi Mathieu,
> 
> As reported at
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13903
> 
> one of my test systems suffers from a hibernation regression where the second
> attempt to hibernate in a row makes it hang solid right before creating the
> image.
> 
> Bisection turned up your commit 3f4a782b5ce2698b1870b5a7b573cd721d4fce33
> ([CPUFREQ] fix (utter) cpufreq_add_dev mess) as the first bad one.
> 

Can you try with the following patch applied ?

http://www.spinics.net/lists/cpufreq/msg00964.html

Subject: [PATCH 1/5] CPUFREQ: Fix a kobject reference bug related to managed CPUs
From: Thomas Renninger <trenn@suse.de>

Thanks,

Mathieu

> Best,
> Rafael

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
