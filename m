Return-Path: <linux-kernel-owner+w=401wt.eu-S1762586AbXIKIJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762586AbXIKIJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759141AbXIKIJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:09:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56379 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759056AbXIKIJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:09:27 -0400
Date: Tue, 11 Sep 2007 09:09:26 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
cc: Zhenyu Wang <zhenyu.z.wang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [AGPGART] intel_agp: fix GTT map size on G33
In-Reply-To: <20070910221502.dba1d5ce.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709110908120.11816@skynet.skynet.ie>
References: <20070905071307.GB5817@zhen-devel.sh.intel.com>
 <20070910221502.dba1d5ce.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Subject: [PATCH] [AGPGART] intel_agp: fix GTT map size on G33
>>
>> G33 has 1MB GTT table range. Fix GTT mapping
>> in case like 512MB aperture size.
>>
>> Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>

Acked-by: Dave Airlie <airlied@linux.ie>

> Ditto.  What happens if this patch isn't in 2.6.23?  And is it applicable to
> and needed in 2.6.22?

It's support for new hardware enablement, so maybe stable requires it, but 
I'm not sure how widespread this hw is yet..

Dave.
