Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbYC1VS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbYC1VS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbYC1VSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:18:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:14877 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114AbYC1VST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:18:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,572,1199692800"; 
   d="scan'208";a="224566205"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: down_spin() implementation
Date: Fri, 28 Mar 2008 14:16:55 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECF237C0@orsmsx424.amr.corp.intel.com>
In-reply-to: <20080328124517.GQ16721@parisc-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: down_spin() implementation
Thread-Index: AciQ0e6kxa7LTjy/SOKC9+7juddiHQARnOog
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com> <1FE6DD409037234FAB833C420AA843ECE9EB1C@orsmsx424.amr.corp.intel.com> <20080327141508.GL16721@parisc-linux.org> <200803281101.25037.nickpiggin@yahoo.com.au> <20080328124517.GQ16721@parisc-linux.org>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Matthew Wilcox" <matthew@wil.cx>, "Nick Piggin" <nickpiggin@yahoo.com.au>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, <linux-arch@vger.kernel.org>,
       <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Mar 2008 21:16:56.0768 (UTC) FILETIME=[0D8E0400:01C89119]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So it makes little sense to add this to semaphores.  Better to introduce
> a spinaphore, as you say.

> struct {
>   atomic_t cur;
>   int max;
> } ss_t;

Could this API sneak into the bottom of one or the other of
linux/include/{spinlock,semaphore}.h ... or should it get its own
spinaphore.h file?

Or should I follow Alan's earlier advice and keep this as an ia64
only thing (since I'll be the only user).

-Tony
