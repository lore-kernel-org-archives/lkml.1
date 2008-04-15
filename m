Return-Path: <linux-kernel-owner+w=401wt.eu-S1764788AbYDOLyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764788AbYDOLyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYDOLxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:53:50 -0400
Received: from saeurebad.de ([85.214.36.134]:54484 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763880AbYDOLxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:53:49 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	<20080412225850.704752615@symbol.fehenstaub.lan>
	<87lk3hwv52.fsf@basil.nowhere.org>
	<20080414232308.ffa4e269.akpm@linux-foundation.org>
	<48045D6C.1010508@firstfloor.org>
Date: Tue, 15 Apr 2008 13:53:38 +0200
In-Reply-To: <48045D6C.1010508@firstfloor.org> (Andi Kleen's message of "Tue,
	15 Apr 2008 09:46:52 +0200")
Message-ID: <87skxnibb1.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Andrew Morton wrote:
>> On Sun, 13 Apr 2008 18:56:57 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>> 
>>> Johannes Weiner <hannes@saeurebad.de> writes:
>>>
>>>> Make free_bootmem() look up the node holding the specified address
>>>> range which lets it work transparently on single-node and multi-node
>>>> configurations.
>>> Acked-by: Andi Kleen <andi@firstfloor.org>
>>>
>>> This is far better than the original change it replaces and which 
>>> I also objected to in review.
>>>
>> 
>> So...  do we think these two patches are sufficiently safe and important for
>> 2.6.25?
>
> It's only strictly needed for .26 I think for some (also slightly
> dubious) changes queued in git-x86.

Does anything yet rely on this new free_bootmem() behaviour?  If not,
the safest thing would be to just revert the original patch in mainline
and drop the second patch completely.

	Hannes
