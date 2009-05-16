Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbZEPPPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbZEPPPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 11:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZEPPPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 11:15:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:55075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbZEPPPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 11:15:45 -0400
Message-ID: <4A0ED8D8.2010303@kernel.org>
Date: Sun, 17 May 2009 00:16:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: suresh.b.siddha@intel.com
CC: "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org> <1242436626.27006.8623.camel@localhost.localdomain>
In-Reply-To: <1242436626.27006.8623.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 16 May 2009 15:15:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Suresh.

Suresh Siddha wrote:
> Tejun, Can you please educate me why we need to map this first
> percpu chunk (which is pre-allocated during boot and is physically
> contiguous) into vmalloc area?

To make areas for each cpu congruent such that the address offset of a
percpu symbol for CPU N is always the same from the address for CPU 0.

> Perhaps even for the other dynamically allocated secondary chunks?
> (as far as I can see, all the chunk allocations seems to be
> physically contiguous and later mapped into vmalloc area)..
> 
> That should simplify these things quite a bit(atleast for first
> percpu chunk).  I am missing something obvious I guess.

Hmm... Sorry I don't really follow.  Can you please elaborate the
question?

thanks.

-- 
tejun
