Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZEVBKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZEVBKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 21:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbZEVBJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 21:09:57 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2733 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZEVBJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 21:09:56 -0400
Subject: Re: [PATCH 1/3] kernel.h: Add DO_ONCE statement expression macro
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Len Brown <len.brown@intel.com>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20090522002717.GV8633@ZenIV.linux.org.uk>
References: <cover.1242943463.git.joe@perches.com>
	 <7b063fda0675875d51a5da49f59e89520d025eee.1242943463.git.joe@perches.com>
	 <20090522002717.GV8633@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 21 May 2009 18:09:45 -0700
Message-Id: <1242954585.3284.7.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 01:27 +0100, Al Viro wrote:
> On Thu, May 21, 2009 at 04:00:22PM -0700, Joe Perches wrote:
> > Add a DO_ONCE statement expression analogous to printk_once
> > that executes any arbitrary statement exactly once.
> > 
> > This will take the place of printk_once so that
> > DO_ONCE(pr_<foo>) or any other statement performed
> > a single time may be easily written.
> 
> Interesting, how telling somebody that they need to learn C is considered
> an unacceptable thing to do.  Hostile to newbies, or some such.  Introducing
> more magic that has to be learnt if one wants to read the kernel source, OTOH,
> is just fine...

I'd be fine if the printk_once macro helper went away.
It was added in commit f036be96dd9ce442ffb9ab33e3c165f5178815c0

If the helper exists though, I think it should work with
all of the pr_<foo> variants.

