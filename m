Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZF2B2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZF2B2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 21:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZF2B1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 21:27:52 -0400
Received: from toq5.bellnexxia.net ([209.226.175.27]:38338 "EHLO
	toq5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZF2B1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 21:27:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An0FAK+yR0pMQWU3/2dsb2JhbACBUckBgkyBQQWDUA
Date: Sun, 28 Jun 2009 21:25:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [Bug #13424] possible deadlock when doing governor switching
Message-ID: <20090629012558.GA22666@Krystal>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.IOG.9jASKB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <5Hhc7UkUKEO.A.IOG.9jASKB@chimera>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:23:31 up 120 days, 21:49,  4 users,  load average: 0.04, 0.27,
	0.30
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 

Yep, it still exists. Venkatesh Pallipadi from Intel is working on it.
We need to figure out a proper way to fix policy rwlock vs dbs_mutex vs
timer mutex dependency.

Mathieu

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13424
> Subject		: possible deadlock when doing governor switching
> Submitter	: Shaohua Li <shaohua.li@intel.com>
> Date		: 2009-05-31 16:36 (29 days old)
> References	: http://www.spinics.net/lists/cpufreq/msg00711.html
> Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
