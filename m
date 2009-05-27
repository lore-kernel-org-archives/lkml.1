Return-Path: <linux-kernel-owner+w=401wt.eu-S1762727AbZE0Mr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762727AbZE0Mr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761143AbZE0MrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:47:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60352 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760904AbZE0MrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:47:18 -0400
Date: Wed, 27 May 2009 14:47:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/19] periodic write-back timer optimization
Message-ID: <20090527124719.GH11363@kernel.dk>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain> <200905271323.29818.arnd@arndb.de> <4A1D31BA.6060903@nokia.com> <20090527123320.GF11363@kernel.dk> <4A1D3418.8060909@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1D3418.8060909@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27 2009, Artem Bityutskiy wrote:
> Jens Axboe wrote:
>> On Wed, May 27 2009, Artem Bityutskiy wrote:
>>> ext Arnd Bergmann wrote:
>>>> On Wednesday 27 May 2009, Artem Bityutskiy wrote:
>>>>> Hi,
>>>>>
>>>>> This is the second attempt. The first one was here:
>>>>> http://marc.info/?l=linux-fsdevel&m=124301072305588&w=2
>>>>> It was very hacky and got no comments.
>>>> How does this relate to the per-BDI writeback patches that
>>>> Jens is working on? Doesn't that require a completely different
>>>> (probably simpler) implementation of your patch?
>>> At a quick glance, our works do not intersect. He seems
>>> to be changing the guts of write-back, while I only touch
>>> the timer which wakes up the periodic write-back thread,
>>> nothing else. I'll try to take Jens' patches and see.
>>
>> There's definitely overlap! The timer is gone with my patches and so is
>> pdflush. For an idle (idle here meaning no background writeback
>> activity) system, there should just be bdi-default running. And that
>> will wake up every dirty_writeback_interval by default.
>
> Hmm, right. Will be working on top of your patches then.

That would be great, I would have no problem integrating such a feature.
It definitely makes sense.

-- 
Jens Axboe

