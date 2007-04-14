Return-Path: <linux-kernel-owner+w=401wt.eu-S1030417AbXDNNbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030417AbXDNNbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 09:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161196AbXDNNbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 09:31:09 -0400
Received: from 65-117-135-114.dia.static.qwest.net ([65.117.135.114]:46218
	"EHLO postfix.timesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030403AbXDNNbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 09:31:08 -0400
X-Greylist: delayed 1471 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2007 09:31:07 EDT
Subject: Re: [RFC] [Patch 0/4] timer_stats slimmed down
From: Thomas Gleixner <tglx@timesys.com>
Reply-To: tglx@timesys.com
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-s390@vger.kernel.org, d.pensator@gmail.com, mingo@redhat.com
In-Reply-To: <1176545387.5462.108.camel@dix>
References: <1176545387.5462.108.camel@dix>
Content-Type: text/plain
Date: Sat, 14 Apr 2007 15:07:27 +0200
Message-Id: <1176556047.3387.64.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin,

On Sat, 2007-04-14 at 12:09 +0200, Martin Peschke wrote:
> 2.6.21-rc* kernels come with a feature that adds timer statistics
> to /proc/timer_stats (CONFIG_TIMER_STATS). This patch set makes it use
> the proposed statistics infrastructure (-mm tree), and adds prequisite
> functions to the statistics code.
> 
> The result are noticeable lines of code savings.
> kernel/time/timer_stats.c which comes with several functions which can
> be made redundant by using corresponding functions of lib/statistic.c,
> that is:
> 
> - accounting
> - printing output in sequential files
> - user interface for switching accounting on/off, reset etc.
> - measuring the accounting time
> - per-cpu optimisations
> 
> Function that were missing in lib/statistics, and which are added by
> this patch set, are:
> 
> - allow arbitrary keys for statistics entries (e.g. structures)
> - allow client to label output of statistics entries (e.g. using keys)
> 
> A secondary effect of the patch set is that we won't add another entry
> to good old /proc. The statistics infrastructure uses debugfs.
> 
> This patch set is a prototype that works for me, but which might allow
> for optimisations. Suggestions are welcome.

I'm a bit short of time to take a closer look, but on the first glance
it looks good to me. I give it a whirl, when I'm back from travelling.

	tglx



