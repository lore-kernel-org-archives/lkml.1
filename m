Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbZEVA12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbZEVA12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 20:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbZEVA1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 20:27:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40100 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZEVA1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 20:27:19 -0400
Date: Fri, 22 May 2009 01:27:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       x86@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/3] kernel.h: Add DO_ONCE statement expression macro
Message-ID: <20090522002717.GV8633@ZenIV.linux.org.uk>
References: <cover.1242943463.git.joe@perches.com> <7b063fda0675875d51a5da49f59e89520d025eee.1242943463.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b063fda0675875d51a5da49f59e89520d025eee.1242943463.git.joe@perches.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 04:00:22PM -0700, Joe Perches wrote:
> Add a DO_ONCE statement expression analogous to printk_once
> that executes any arbitrary statement exactly once.
> 
> This will take the place of printk_once so that
> DO_ONCE(pr_<foo>) or any other statement performed
> a single time may be easily written.

Interesting, how telling somebody that they need to learn C is considered
an unacceptable thing to do.  Hostile to newbies, or some such.  Introducing
more magic that has to be learnt if one wants to read the kernel source, OTOH,
is just fine...
