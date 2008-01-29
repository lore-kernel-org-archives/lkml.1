Return-Path: <linux-kernel-owner+w=401wt.eu-S1759387AbYA2UoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbYA2UoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYA2Unu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:43:50 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:56585
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbYA2Unt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:43:49 -0500
Message-ID: <479F8F83.2030809@qumranet.com>
Date: Tue, 29 Jan 2008 22:41:39 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/6] mmu_notifier: Core code
References: <20080128202840.974253868@sgi.com> <20080128202923.609249585@sgi.com> <20080129135914.GF7233@v2.random> <Pine.LNX.4.64.0801291148080.24807@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0801291148080.24807@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Tue, 29 Jan 2008 22:41:39 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 29 Jan 2008, Andrea Arcangeli wrote:
>
>   
>>> +	struct mmu_notifier_head mmu_notifier; /* MMU notifier list */
>>>  };
>>>       
>> Not sure why you prefer to waste ram when MMU_NOTIFIER=n, this is a
>> regression (a minor one though).
>>     
>
> Andrew does not like #ifdefs and it makes it possible to verify calling 
> conventions if !CONFIG_MMU_NOTIFIER.
>
>   

You could define mmu_notifier_head as an empty struct in that case.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

