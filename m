Return-Path: <linux-kernel-owner+w=401wt.eu-S1764118AbZAOTVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764118AbZAOTVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 14:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbZAOTVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 14:21:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:39473 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947AbZAOTVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 14:21:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,271,1231142400"; 
   d="scan'208";a="100433383"
From: "Luck, Tony" <tony.luck@intel.com>
To: Greg KH <greg@kroah.com>, Dimitri Sivanich <sivanich@sgi.com>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>,
       Tony Luck <tony.luck@gmail.com>, Robin Holt <holt@sgi.com>
Date: Thu, 15 Jan 2009 11:21:05 -0800
Subject: RE: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Thread-Topic: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Thread-Index: Acl3Q/0bhiqNse2gTTOLuiOUC1Q07QAAfIeA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35CD8C4C3@orsmsx505.amr.corp.intel.com>
References: <20090106162741.GA7991@sgi.com>
 <20090115184832.GE10674@kroah.com>
In-Reply-To: <20090115184832.GE10674@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Greg, if everyone is OK with this patch, this should also be applied
> > to all stable trees starting with 2.6.26.

> What is the status of this going into Linus's tree?

I'm about to ask Linus to pull a modified version that does
a "select HAVE_UNSTABLE_SCHED_CLOCK" for all IA64 systems ...
SGI sched_clock() is a lot less "stable" than most, but all
ia64 systems can hit this as the ar.itc cycle counter is only
s/w synchronized between cpus.

-Tony
