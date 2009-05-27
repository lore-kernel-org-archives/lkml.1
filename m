Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbZE0Mi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbZE0Mi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZE0MiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:38:15 -0400
Received: from smtp.nokia.com ([192.100.122.230]:19042 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZE0MiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:38:14 -0400
Message-ID: <4A1D3418.8060909@nokia.com>
Date: Wed, 27 May 2009 15:37:44 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Arnd Bergmann <arnd@arndb.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/19] periodic write-back timer optimization
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain> <200905271323.29818.arnd@arndb.de> <4A1D31BA.6060903@nokia.com> <20090527123320.GF11363@kernel.dk>
In-Reply-To: <20090527123320.GF11363@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 May 2009 12:37:49.0192 (UTC) FILETIME=[F1B6D880:01C9DEC7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, May 27 2009, Artem Bityutskiy wrote:
>> ext Arnd Bergmann wrote:
>>> On Wednesday 27 May 2009, Artem Bityutskiy wrote:
>>>> Hi,
>>>>
>>>> This is the second attempt. The first one was here:
>>>> http://marc.info/?l=linux-fsdevel&m=124301072305588&w=2
>>>> It was very hacky and got no comments.
>>> How does this relate to the per-BDI writeback patches that
>>> Jens is working on? Doesn't that require a completely different
>>> (probably simpler) implementation of your patch?
>> At a quick glance, our works do not intersect. He seems
>> to be changing the guts of write-back, while I only touch
>> the timer which wakes up the periodic write-back thread,
>> nothing else. I'll try to take Jens' patches and see.
> 
> There's definitely overlap! The timer is gone with my patches and so is
> pdflush. For an idle (idle here meaning no background writeback
> activity) system, there should just be bdi-default running. And that
> will wake up every dirty_writeback_interval by default.

Hmm, right. Will be working on top of your patches then.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
