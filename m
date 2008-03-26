Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbYCZCQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbYCZCQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 22:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYCZCQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 22:16:15 -0400
Received: from testure.choralone.org ([194.9.77.134]:40010 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYCZCQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 22:16:15 -0400
Date: Tue, 25 Mar 2008 22:15:54 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 04/12] cpumask: pass cpumask by reference to
	acpi-cpufreq
Message-ID: <20080326021554.GA8388@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Mike Travis <travis@sgi.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
References: <20080326013811.569646000@polaris-admin.engr.sgi.com> <20080326013812.324977000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326013812.324977000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 06:38:15PM -0700, Mike Travis wrote:
 > Pass cpumask_t variables by reference in acpi-cpufreq functions.
 > 
 > Based on:
 > 	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
 > 	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
 > 
 > Cc: Len Brown <len.brown@intel.com>
 > Cc: Dave Jones <davej@codemonkey.org.uk>
 > Signed-off-by: Mike Travis <travis@sgi.com>

As this is dependant on non-cpufreq bits, I'm assuming this is going
via Ingo.  From a quick eyeball of this, and the change its dependant on,
it looks ok to me.

	Dave

-- 
http://www.codemonkey.org.uk
