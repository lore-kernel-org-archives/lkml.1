Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZGGBwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZGGBwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 21:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZGGBwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 21:52:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34828 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZGGBv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 21:51:59 -0400
Date: Mon, 6 Jul 2009 21:51:15 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: cpufreq cleanups - .30 vs .31
Message-ID: <20090707015115.GB5310@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org, kernel-testers@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Dave Young <hidave.darkstar@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <200907061318.20839.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907061318.20839.trenn@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 01:18:18PM +0200, Thomas Renninger wrote:

 > So if not find too intrusive, I'd say:
 > Venkatesh's whole series of:
 > [patch 0/4] Take care of cpufreq lockdep issues (take 2)
 > should be seen in .31.
 >  ...
 > The one patch from Mathieu:
 > [patch 2.6.30 2/4] CPUFREQ: fix (utter) cpufreq_add_dev mess
 > is a separate, general cleanup which should show up in .31.

I came to the same conclusion after reading the thread, and looking
over the patches.  I merged the above, and sent Linus a pull request
a few minutes ago.

Thanks Mathieu and Venki for chasing this down.

	Dave
