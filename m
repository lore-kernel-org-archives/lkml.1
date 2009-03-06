Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbZCFTz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbZCFTz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZCFTzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:55:11 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:37966
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751168AbZCFTzK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:55:10 -0500
X-BigFish: VPS-27(zz1432R98dR1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KG3ONF-01-D53-01
Date: Fri, 6 Mar 2009 20:54:56 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/18] dma-debug: add hash functions for dma_debug_entries
Message-ID: <20090306195456.GF6966@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com> <1236346229-6618-4-git-send-email-joerg.roedel@amd.com> <20090306135052.GE5988@nowhere> <20090306184514.GE7420@localhost> <20090306191059.GE7329@nowhere> <20090306191641.GF7420@localhost> <20090306192535.GD6966@amd.com> <20090306193823.GG7420@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090306193823.GG7420@localhost>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 06 Mar 2009 19:54:56.0886 (UTC) FILETIME=[6CC3D960:01C99E95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 10:38:23PM +0300, Cyrill Gorcunov wrote:
> [Joerg Roedel - Fri, Mar 06, 2009 at 08:25:35PM +0100]
> ...
> | > Nod :) The only problem could be (it depends) -- is that
> | > if one day some locking would be needed instead of fixing
> | > one function you would need to grep all list_add/del entries :)
> | 
> | The access is already locked. And as the functions are only called
> | once each gcc should inline them automatically. At least gcc inlined
> | them in my kernels :)
> | 
> | 	Joerg
> 
> I didn't checked the precise code logic neither details, just wanted
> to point out that 'wrapping' functions are beneficial sometimes (especially
> when they hide details of internal data and provide some kind of interface
> to play with).

True. I agree with this. These functions improve the readability of the
code imho.

> Dunno Joerg, I think it would be better to point out that we want
> those functions being inlined by gcc 'inline' attribute explicitly.
> But you choose :)

Yeah, I think its better to let gcc choose what to inline and what not.
It has a good heuristic for that task :)

	Joerg


-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

