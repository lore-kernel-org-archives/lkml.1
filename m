Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbXH1Uut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbXH1Uut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXH1Uum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:50:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55202 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbXH1Uul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:50:41 -0400
Date: Tue, 28 Aug 2007 21:50:39 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Christoph Hellwig <hch@infradead.org>
cc: m.kozlowski@tuxland.pl, akpm@linux-foundation.org,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] drm: introduce drm_zalloc
In-Reply-To: <20070828200821.GA7998@infradead.org>
Message-ID: <Pine.LNX.4.64.0708282149180.15296@skynet.skynet.ie>
References: <20070827205750.514001000@tuxland.pl> <20070828200821.GA7998@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007, Christoph Hellwig wrote:

> On Mon, Aug 27, 2007 at 10:57:50PM +0200, m.kozlowski@tuxland.pl wrote:
>> Hello,
>>
>> 	As there are many places in drm code where drm_alloc + memset is used
>> this patch series introduces drm_zalloc and also makes use of drm_calloc where
>> needed. Most of these patches save some bytes so the benefit is a few kB saved
>> (gcc 4.1.2) with patch applied. Also some small (style, etc.) things are fixed.
>> This patch series does the conversion drm tree-wide. All patches were compile
>> tested.
>
> Please just convert it to plain kzalloc/kcalloc and kill these utterly useless
> wrappers instead.
>
>

The wrappers aren't useless the drm alloc/free passes in a memory space 
for debugging purposes so we can track memory abuse when developing,

but drm_zalloc shouldjust alias to drm_calloc really..

Dave.
