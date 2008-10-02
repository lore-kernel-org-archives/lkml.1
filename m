Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYJBS71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYJBS71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 14:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbYJBS7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 14:59:07 -0400
Received: from www.tglx.de ([62.245.132.106]:60127 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbYJBS7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 14:59:06 -0400
Date: Thu, 2 Oct 2008 20:58:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Olaf Kirch <okir@suse.de>
cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, "Graham, David" <david.graham@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>, chris.jones@canonical.com,
       tim.gardner@intel.com, airlied@gmail.com
Subject: Re: [RFC PATCH 07/12] e1000e: debug contention on NVM SWFLAG
In-Reply-To: <200810021933.23677.okir@suse.de>
Message-ID: <alpine.LFD.1.10.0810022057530.5549@apollo.tec.linutronix.de>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com> <200810021703.43770.okir@suse.de> <36D9DB17C6DE9E40B059440DB8D95F52064FB25C@orsmsx418.amr.corp.intel.com> <200810021933.23677.okir@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008, Olaf Kirch wrote:

> On Thursday 02 October 2008 18:27:12 Brandeburg, Jesse wrote:
> > so, why now?  Drivers since before the e1000/e1000e split had this same
> > code, with no reports of problems.  This code has been heavily tested,
> > and one of the platforms easily reproducing this has been available for
> > 3 years now (ich8), with code that is basically unchanged in the driver.
> 
> Possibly the dhcp client is doing something differently, or at a much higher
> frequency. At any rate, it seems we're seeing this now even when we just
> use init level 3, without X involvement. Karsten reports NVM corruption
> after 34 reboots into init level 3.

Had Karsten the mutex patch applied or not ?

    tglx
