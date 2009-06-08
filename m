Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZFHUNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZFHUNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZFHUNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:13:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58066 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZFHUNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:13:07 -0400
Message-ID: <4A2D70BF.9090605@redhat.com>
Date: Mon, 08 Jun 2009 23:12:47 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: aarcange@redhat.com, akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       chrisw@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mmotm] ksm: stop scan skipping pages
References: <1242261048-4487-1-git-send-email-ieidus@redhat.com> <Pine.LNX.4.64.0906081555360.22943@sister.anvils> <Pine.LNX.4.64.0906081733390.7729@sister.anvils> <4A2D4D9F.8080103@redhat.com> <Pine.LNX.4.64.0906081852540.8764@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0906081852540.8764@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 8 Jun 2009, Izik Eidus wrote:
>   
>> Thanks for the fix,
>> (I saw it while i wrote the RFC patch for the madvise, but beacuse that i
>> thought that the RFC fix this (you can see the removel of the second call to
>> scan_get_next_index()), and we move to madvise, I thought that no patch is
>> needed for this code, guess I was wrong)
>>     
>
> Ah, no, I hadn't noticed that, this patch is from several weeks ago,
> before you even posted the madvise() version.
>
> I think myself that we ought to fix the algorithm as it stands now in
> mmotm, rather than hiding the fix in amongst later interface changes.
>
> But it's not a big deal, so long as it gets fixed in the end.
>
> By the time Andrew sends KVM to Linus, it shouldn't be the
> patches currently in mmotm with more on top: 

So you want a repost of all the patchs?, in that case any value to keep 
this stuff in Andrew tree right now?
Wouldnt it speed our development if we will keep it outside, and then 
repost the whole thing?

> they should be
> re-presented with all trace of /dev/ksm gone by then.
>
> Hugh
>   

