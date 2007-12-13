Return-Path: <linux-kernel-owner+w=401wt.eu-S1762682AbXLMRyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762682AbXLMRyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbXLMRye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:54:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbXLMRyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:54:32 -0500
Date: Thu, 13 Dec 2007 12:50:38 -0500
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       venkatesh.pallipadi@intel.com
Subject: Re: [crash] kernel BUG at drivers/cpufreq/cpufreq.c:1060!
Message-ID: <20071213175038.GD28148@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>, venkatesh.pallipadi@intel.com
References: <20071212091144.GA11986@elte.hu> <20071212164013.GA2359@redhat.com> <20071212181828.GA27675@redhat.com> <20071213101711.GN8977@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213101711.GN8977@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 11:17:11AM +0100, Ingo Molnar wrote:
 > 
 > * Dave Jones <davej@redhat.com> wrote:
 > 
 > >  > It _looks_ like we're leaking a refcount on that lock, but I don't 
 > >  > see where.  It's a shame you can't reproduce this easily, as 
 > >  > cpufreq.debug=7 would give us more clues. (And 
 > >  > CONFIG_CPUFREQ_DEBUG=y)
 > > 
 > > So we're missing some unlocks in some error paths. It's feasible you 
 > > hit one of those. This patch should be the fix for that.
 > 
 > since it's not really reproducible (i failed to get it since then), how 
 > about you push your fix upstream (it's an obviously correct fix), we 
 > consider this regression fixed and i'll re-notify you if there's still 
 > any problem left. It's not like there's any escape from make randconfig 
 > bootup test coverage in the long run ;-)

Yeah, will push it to Linus today.

	Dave

-- 
http://www.codemonkey.org.uk
