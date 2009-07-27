Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbZG0Qwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbZG0Qwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZG0Qwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:52:32 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:56504 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbZG0Qwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:52:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAIACJzbUpMQWXi/2dsb2JhbACBUYEwzlWCP4FNBQ
Date: Mon, 27 Jul 2009 12:52:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [Bug #13475] suspend/hibernate lockdep warning
Message-ID: <20090727165228.GC25626@Krystal>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.0KH.4XObKB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <H5-1lZIIeYK.A.0KH.4XObKB@chimera>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:48:21 up 149 days, 13:14,  3 users,  load average: 0.50, 0.38,
	0.40
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be fixed now by recents commits to the cpufreq tree, which got  
into mainline: 

42a06f2166f2f6f7bf04f32b4e823eacdceafdc9
b253d2b2d28ead6fed012feb54694b3d0562839a
b14893a62c73af0eca414cfed505b8c09efc613c
7d26e2d5e2da37e92c6c7644b26b294dedd8c982
37c90e8887efd218dc4af949b7f498ca2da4af9f
5a75c82828e7c088ca6e7b4827911dc29cc8e774
ee88415caf736b89500f16e0a545614541a45005
3f4a782b5ce2698b1870b5a7b573cd721d4fce33
5e1596f75395e7a402e1059c518e633d2732dcf8

Mathieu


* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13475
> Subject		: suspend/hibernate lockdep warning
> Submitter	: Dave Young <hidave.darkstar@gmail.com>
> Date		: 2009-06-02 10:00 (55 days old)
> References	: http://marc.info/?l=linux-kernel&m=124393723321241&w=4
> Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Patch		: http://patchwork.kernel.org/patch/28660/
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
