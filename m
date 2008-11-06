Return-Path: <linux-kernel-owner+w=401wt.eu-S1751042AbYKFWv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042AbYKFWv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYKFWvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:51:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53619 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYKFWvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:51:20 -0500
To: Chris Snook <csnook@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] change CONFIG_NUMA description
From: Andi Kleen <andi@firstfloor.org>
References: <20081105022553.7CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<4910A43B.5030908@redhat.com>
Date: Thu, 06 Nov 2008 23:51:28 +0100
In-Reply-To: <4910A43B.5030908@redhat.com> (Chris Snook's message of "Tue, 04 Nov 2008 14:36:27 -0500")
Message-ID: <87bpwso4cv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook <csnook@redhat.com> writes:

> KOSAKI Motohiro wrote:
>> CONFIG_NUMA description talk about a bit old thing.
>> So, following changes are better.
>> o CONFIG_NUMA is no longer EXPERIMENTAL
>> o Opteron is not the only processor of NUMA topology on x86_64 no longer, but also Intel Core7i has it.
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> a) It's Core i7, not Core 7i
> b) Core i7 is, at least so far, the single-socket version, so NUMA
> doesn't apply.
>
> I think we should let Intel write the CONFIG_NUMA description for
> Nehalem processors.

The recommendation should be imho just to always enable it. Back 
when I wrote the description it was still experimental, but 
it really isn't anymore.

-Andi

-- 
ak@linux.intel.com
