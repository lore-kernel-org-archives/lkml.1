Return-Path: <linux-kernel-owner+w=401wt.eu-S933406AbXLNA27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbXLNA27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933223AbXLNA2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:28:30 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36184 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbXLNA22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:28:28 -0500
Date: Fri, 14 Dec 2007 00:28:25 +0000 (GMT)
From: Dave Airlie <airlied@skynet.ie>
To: venkatesh.pallipadi@intel.com
cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/12] PAT 64b: PAT support for X86_64
In-Reply-To: <20071213235543.568682000@intel.com>
Message-ID: <alpine.DEB.0.82.0712140023550.27550@skynet.skynet.ie>
References: <20071213235543.568682000@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes. It is that wonderful time of the year again.
> No, no. We are not talking about holiday season or new year here.
> 
> We are talking about one another rehash of "why we do not support PAT in x86"
> question and series of patches that implement some PAT support before going
> into hibernation again. Only difference is that we hope to take this little
> further this time and may be really get this support into
> upstream kernel soon.

Woot, PAT support: this time we mean it!!

I'll just give one comment after a reading your todo..

> * Do we need to allow RAM pages to be mapped as WC? If not, then
>   we don't need to follow the TLB flush mechanism (make pte not present,
>   flush, and set pte with new mapping) mentioned in section 10.12.4 of SDM
>   Vol3a.

Yes, the main use for GPUs is to have RAM pages mapped WC, and placed into 
a GART on the GPU side, currently for Intel IGD we are okay as the CPU can 
access the GPU GART aperture, but other chips exist where this isn't 
possible, I think poulsbo and possible some of the AMD IGPs..

Dave.
