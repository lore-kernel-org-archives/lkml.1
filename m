Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab0CCCJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 21:09:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:18435 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab0CCCJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 21:09:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,570,1262592000"; 
   d="scan'208";a="497205395"
Date: Wed, 3 Mar 2010 10:08:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@linux.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sachin Sant <sachinp@in.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Alok Kataria <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>
Subject: Re: [GIT PULL] x86/mm fixes
Message-ID: <20100303020845.GD6477@localhost>
References: <201003020010.o220Ax3Z025848@hera.kernel.org> <alpine.LFD.2.00.1003021038410.3616@localhost.localdomain> <4B8D67A4.8080602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8D67A4.8080602@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 03:31:48AM +0800, H. Peter Anvin wrote:
> On 03/02/2010 10:39 AM, Linus Torvalds wrote:
> > 
> > 
> > On Tue, 2 Mar 2010, H. Peter Anvin wrote:
> >> +		pfn = (res.start + PAGE_SIZE - 1) >> PAGE_SHIFT;
> >> +		end_pfn = (res.end + 1) >> PAGE_SHIFT;
> >> +		if (end_pfn > pfn)
> >> +		    ret = (*func)(pfn, end_pfn - pfn, arg);
> >>  		if (ret)
> >>  			break;
> >>  		res.start = res.end + 1;
> > 
> > What kind of messed-up indentation is that? We don't use 4-char indents.
> > 
> 
> Branch updated with an indentation patch.  Sorry about that.

Sorry! Wondering I didn't do the indent with the vim '=='.

Anyway I just hacked /usr/share/quilt/refresh to automatically run the
kernel style checker:

# wfg: check for kernel coding style
if [ -x scripts/checkpatch.pl ]; then
        scripts/checkpatch.pl $patch_file
fi

Thanks,
Fengguang
