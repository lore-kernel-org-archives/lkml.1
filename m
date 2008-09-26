Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYIZGNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYIZGNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 02:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYIZGNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 02:13:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:41319 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752141AbYIZGND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 02:13:03 -0400
Date: Fri, 26 Sep 2008 08:13:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, agospoda@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
Message-ID: <alpine.LNX.1.10.0809260812130.14480@pegasus.suse.cz>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com> <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008, Brandeburg, Jesse wrote:

> this is the current set of patches that I have to help us debug
> and/or fix e1000e issues found during this debug effort for
> the corrupt NVM.  the "drop stats lock" - "reset swflag" patches allow 
> Thomas' patch for a mutex in the SWFLAG acquire function to run without 
> any errors.

Thanks. Also Jesse Barnes' patch shouldn't be forgotten, could you please 
add it to that lineup?

	http://marc.info/?l=linux-kernel&m=122237193628087&w=2

-- 
Jiri Kosina
SUSE Labs
