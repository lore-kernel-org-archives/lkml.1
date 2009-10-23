Return-Path: <linux-kernel-owner+w=401wt.eu-S1751494AbZJWAM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbZJWAM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 20:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZJWAM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 20:12:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:5405 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbZJWAM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 20:12:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,608,1249282800"; 
   d="scan'208";a="506390646"
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>,
       Thomas Schlichter <thomas.schlichter@web.de>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20091023081047.4d8abc29@jbarnes-x200>
References: <1394846127@web.de>
	 <4ADF32A0020000780001B20A@vpn.id2.novell.com>
	 <20091021173514.GA32227@elte.hu>
	 <200910212201.36578.thomas.schlichter@web.de>
	 <1256205210.2530.28.camel@sbs-t61>
	 <1256225689.32075.6.camel@gaiman.anholt.net>
	 <1256248050.2546.9.camel@sbs-t61>  <20091023081047.4d8abc29@jbarnes-x200>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 22 Oct 2009 17:11:57 -0700
Message-Id: <1256256717.2534.6.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 16:10 -0700, Jesse Barnes wrote:
> On Thu, 22 Oct 2009 14:47:30 -0700
> Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > On Thu, 2009-10-22 at 08:34 -0700, Eric Anholt wrote:
> > > Can we just not create the _wc sysfs entry if we don't have PAT?  I
> > > don't think there's userland relying on its presence as opposed to
> > > the non-_wc entry.
> > 
> > Yes indeed. Jesse do you see an issue with this? This is simple and
> > clean. Thanks Eric.
> 
> Yeah, I think that will be fine.  In fact, older versions of
> libpciaccess will behave better if we do it that way (iirc it only
> allocates an MTRR if the resource_wc file doesn't exist or fails to get
> mapped).

Eric, care to send the patch?

