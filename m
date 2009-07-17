Return-Path: <linux-kernel-owner+w=401wt.eu-S933945AbZGQBgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbZGQBgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 21:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933933AbZGQBgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 21:36:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:53858 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933931AbZGQBgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 21:36:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,414,1243839600"; 
   d="scan'208";a="708566429"
Subject: Re: [PATCH 0/8] device async action mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <4A5F2EEC.8010508@linux.intel.com>
References: <1247643512.26272.74.camel@rzhang-dt>
	 <87ocrm6xeq.fsf@basil.nowhere.org> <1247710483.26272.170.camel@rzhang-dt>
	 <20090716114020.GA11928@khazad-dum.debian.net>
	 <4A5F2EEC.8010508@linux.intel.com>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 09:37:00 +0800
Message-Id: <1247794620.26272.213.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 21:45 +0800, Arjan van de Ven wrote:
> Henrique de Moraes Holschuh wrote:
> > On Thu, 16 Jul 2009, Zhang Rui wrote:
> >> the kernel device suspend time is reduced from 3.2s to 2.8s after
> >> applying this patch set in my test box.
> > 
> > It will give even a bigger boot time saving on ThinkPads, where there is a
> > Synaptics (or ALPS if you are unlucky) touchpad with the trackpoint behind
> > it... it takes about 2s to init both devices here.  That's two seconds of
> > boot time you can shove off if it is being initialized assyncronously :-)
> > 
> 
> that's a different problem that I don't think this will solve;

right.
we are not able to get an async device group during initialization.

thanks,
rui

>  as long
> as you keep the boot of the kernel wait for all async actions, you're going
> to hit that wait. In Moblin we have a (bad) patch to not do the wait,
> at some point we need to figure how to get a mainline-able patch....

