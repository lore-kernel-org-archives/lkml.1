Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbYKZNFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbYKZNFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbYKZNDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:03:42 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35100 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbYKZNDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:03:41 -0500
Message-ID: <492D4927.8040204@davidnewall.com>
Date: Wed, 26 Nov 2008 23:33:35 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Andrew Morton <akpm@linux-foundation.org>, john@johnmccutchan.com,
       arnd@arndb.de, mtk.manpages@gmail.com, hch@lst.de, rlove@rlove.org,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, pavel@suse.cz,
       Eric Paris <eparis@redhat.com>
Subject: Re: [take2] Inotify: nested attributes support.
References: <20081125194234.GA24449@ioremap.net> <20081125162434.4feacbbf.akpm@linux-foundation.org> <20081126074239.GA17525@ioremap.net> <20081126001538.4b1c7c99.akpm@linux-foundation.org> <20081126082936.GB17525@ioremap.net> <492D4560.8000302@davidnewall.com> <20081126125113.GA8921@ioremap.net>
In-Reply-To: <20081126125113.GA8921@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Wed, Nov 26, 2008 at 11:17:28PM +1030, David Newall (davidn@davidnewall.com) wrote:
>   
>> I don't think so.  As discussed,
>> (http://marc.info/?l=linux-kernel&m=122735413932519), you already can
>> differentiate I/O made by local users, so you don't need to modify inotify.
>>     
>
> And as was shown it does not work for all cases and introduces unneded
> performance overhead.
>   

If the performance using a local loopback is insufficient, or even when
using a UNIX domain socket, then it's going to be even worse for the
actual network-connected clients.  And the cases were it doesn't work
amount to poor system administration, which is a solvable problem.


>> This change violates my first rule of programming: If there's two or
>> more ways of solving a problem, pick one; don't pick them all.
>>     
>
> Then we should go back to caves, raw meat was so tasty...

Amusing, but irrelevant to programming.
