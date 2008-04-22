Return-Path: <linux-kernel-owner+w=401wt.eu-S932297AbYDVWWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbYDVWWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757973AbYDVWWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:22:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:37205 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618AbYDVWWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:22:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,696,1199692800"; 
   d="scan'208";a="555831354"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [Patch 1/4] move XP and XPC to drivers/misc/sgi-xp -v4
Date: Tue, 22 Apr 2008 15:21:53 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC012AF549@orsmsx424.amr.corp.intel.com>
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC012AF3D7@orsmsx424.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 1/4] move XP and XPC to drivers/misc/sgi-xp -v4
Thread-Index: Aciksammli5Wt11PSNOWfGGaft1thgACO2ZgAAMNtUA=
References: <20080422194459.GB13086@sgi.com> <20080422194656.GA14628@sgi.com> <1FE6DD409037234FAB833C420AA843EC012AF3D7@orsmsx424.amr.corp.intel.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "Dean Nelson" <dcn@sgi.com>
Cc: <jes@sgi.com>, <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 22 Apr 2008 22:21:53.0795 (UTC) FILETIME=[44B0E530:01C8A4C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I applied this series on top of this morning's patch to change
> the uncached allocator to support multiple page allocations.

I've now dropped the change to the uncached allocator. You'll need
to update this patch with the changes to the users of 
uncached_{alloc,free}_page.

Using the older one-page version your patches to move XP and
XPC all apply, and I see no build errors (I don't have a system
on which to check that this works).

-Tony
