Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYJDKVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYJDKVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 06:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbYJDKVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 06:21:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:40505 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752214AbYJDKVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 06:21:41 -0400
Date: Sat, 4 Oct 2008 12:21:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>, jesse.brandeburg@intel.com,
       linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
       kkeil@suse.de, agospoda@redhat.com, arjan@linux.intel.com,
       david.graham@intel.com, bruce.w.allan@intel.com, john.ronciak@intel.com,
       Thomas Gleixner <tglx@linutronix.de>, chris.jones@canonical.com,
       tim.gardner@intel.com, airlied@gmail.com, Olaf Kirch <okir@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 02/12] On Tue, 23 Sep 2008, David Miller wrote:
In-Reply-To: <4807377b0810031628x43f79eferdbb9c9c264a5816e@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0810041219130.26779@jikos.suse.cz>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>  <200810021523.45884.jbarnes@virtuousgeek.org>  <20081003.134634.240211201.davem@davemloft.net>  <200810031429.22598.jbarnes@virtuousgeek.org>  <alpine.LNX.1.10.0810032338140.26779@jikos.suse.cz>
 <4807377b0810031628x43f79eferdbb9c9c264a5816e@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Jesse Brandeburg wrote:

> Our experience is different.  We are also testing with the "protection 
> patch" reverted.
> We see that the problem specifically comes and goes when
> removing/adding the use of set_memory_ro/set_memory_rw to the driver.

But if this patch (which is an obvious workaround, compared to the other 
patches which fix real bugs, right?) would be catching some malicious 
accessess to the mapped EEPROM, there should be stacktraces present in the 
kernel log, right?

Thanks,

-- 
Jiri Kosina
SUSE Labs
