Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbYJBTHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbYJBTHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYJBTH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:07:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:39820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbYJBTH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:07:27 -0400
From: Olaf Kirch <okir@suse.de>
Organization: SUSE LINUX Products GmbH
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 07/12] e1000e: debug contention on NVM SWFLAG
Date: Thu, 2 Oct 2008 21:07:22 +0200
User-Agent: KMail/1.9.9
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, "Graham, David" <david.graham@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>, chris.jones@canonical.com,
       tim.gardner@intel.com, airlied@gmail.com
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com> <200810021933.23677.okir@suse.de> <alpine.LFD.1.10.0810022057530.5549@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0810022057530.5549@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810022107.23487.okir@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2008 20:58:43 Thomas Gleixner wrote:
> On Thu, 2 Oct 2008, Olaf Kirch wrote:
> 
> > On Thursday 02 October 2008 18:27:12 Brandeburg, Jesse wrote:
> > > so, why now?  Drivers since before the e1000/e1000e split had this same
> > > code, with no reports of problems.  This code has been heavily tested,
> > > and one of the platforms easily reproducing this has been available for
> > > 3 years now (ich8), with code that is basically unchanged in the driver.
> > 
> > Possibly the dhcp client is doing something differently, or at a much higher
> > frequency. At any rate, it seems we're seeing this now even when we just
> > use init level 3, without X involvement. Karsten reports NVM corruption
> > after 34 reboots into init level 3.
> 
> Had Karsten the mutex patch applied or not ?

That was openSuse 11.1 without any patches

Olaf
-- 
Neo didn't bring down the Matrix. SOA did.
				--soafacts.com

