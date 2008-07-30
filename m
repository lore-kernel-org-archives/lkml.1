Return-Path: <linux-kernel-owner+w=401wt.eu-S1761293AbYG3Xlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293AbYG3Xlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760373AbYG3XlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:41:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:28821 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbYG3XlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:41:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,282,1215414000"; 
   d="scan'208";a="27637995"
Date: Wed, 30 Jul 2008 16:41:03 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080730234102.GF11223@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com> <488FA318.3040905@zytor.com> <20080729232951.GB11223@linux-os.sc.intel.com> <488FAB2B.7050405@zytor.com> <20080730100326.GA9683@elte.hu> <20080730182539.GA17140@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730182539.GA17140@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 11:25:39AM -0700, Ingo Molnar wrote:
> I briefly merged it into tip/master to test it, but after about 10
> randconfig iterations it ran into a spontaneous reboot crash. There's
> nothing in the log, the box (an Athlon64 X2) just reboots spontaneously.
> Removing the x86/xsave changes makes the system boot up fine.
> 
> I've pushed out the tree i tested into the tip/tmp.x86/xsave.broken
> branch. The bad config is:
> 
>   http://redhat.com/~mingo/misc/config-Wed_Jul_30_20_09_12_CEST_2008.bad

Ingo, 2.6.25, 2.6.26 also reboots randomly with this config on my dual-socket
system.
