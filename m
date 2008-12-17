Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759679AbYLQJfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbYLQJfP (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYLQJe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:34:58 -0500
Received: from smtp.nokia.com ([192.100.122.230]:62914 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbYLQJe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:34:57 -0500
Message-ID: <4948C71C.2000700@nokia.com>
Date: Wed, 17 Dec 2008 11:32:12 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Woodhouse <David.Woodhouse@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Adrian Hunter <ext-adrian.hunter@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: mtd tree build failures (Was: Re: linux-next: Tree
 for December 16)
References: <20081216223754.0c8e21d4.sfr@canb.auug.org.au>	<20081216152607.f232fafd.akpm@linux-foundation.org> <20081217175911.594ae84f.sfr@canb.auug.org.au>
In-Reply-To: <20081217175911.594ae84f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Dec 2008 09:34:28.0593 (UTC) FILETIME=[A856E610:01C9602A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Stephen Rothwell wrote:
> On Tue, 16 Dec 2008 15:26:07 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
>> This MTD patch:
>>
>> commit 69423d99fc182a81f3c5db3eb5c140acc6fc64be
>> Author:     Adrian Hunter <ext-adrian.hunter@nokia.com>
>> AuthorDate: Wed Dec 10 13:37:21 2008 +0000
>> Commit:     David Woodhouse <David.Woodhouse@intel.com>
>> CommitDate: Wed Dec 10 13:37:21 2008 +0000
>>
>>     [MTD] update internal API to support 64-bit device size
>>
>> broke the i386 build:
> 
> Also a few arm configs and the m68k allmodconfig.  I shall revert the mtd
> tree from linux-next today.

It would be nice if you sent the error messages. I do not have m68k
compilers, but I could fix the errors anyway, because it is just
about doing divisions with 'do_div()'.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
