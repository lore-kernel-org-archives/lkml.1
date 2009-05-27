Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbZE0M2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbZE0M2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZE0M2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:28:23 -0400
Received: from smtp.nokia.com ([192.100.122.230]:17569 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZE0M2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:28:23 -0400
Message-ID: <4A1D31BA.6060903@nokia.com>
Date: Wed, 27 May 2009 15:27:38 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 00/19] periodic write-back timer optimization
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain> <200905271323.29818.arnd@arndb.de>
In-Reply-To: <200905271323.29818.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 May 2009 12:27:42.0963 (UTC) FILETIME=[885FA430:01C9DEC6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Arnd Bergmann wrote:
> On Wednesday 27 May 2009, Artem Bityutskiy wrote:
>> Hi,
>>
>> This is the second attempt. The first one was here:
>> http://marc.info/?l=linux-fsdevel&m=124301072305588&w=2
>> It was very hacky and got no comments.
> 
> How does this relate to the per-BDI writeback patches that
> Jens is working on? Doesn't that require a completely different
> (probably simpler) implementation of your patch?

At a quick glance, our works do not intersect. He seems
to be changing the guts of write-back, while I only touch
the timer which wakes up the periodic write-back thread,
nothing else. I'll try to take Jens' patches and see.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
