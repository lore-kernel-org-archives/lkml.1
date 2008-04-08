Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYDHRfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYDHRfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 13:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYDHRfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 13:35:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:12262 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYDHRfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 13:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bILmlb5rpIbZOhK+7I+OQDZG9o6EHQDHw9BcKF5qaVO0Y9v5ftjt59128ODJFtTfP1Hwq4RgzxQ4aZaPVJLaH9jwxqzd2dq7N85di4T+MZHAyIj64S7L/kTywFzPrzRO04H6JHQfBB0hTZKc6mAcXmk9tvbhNCBKvvcwx8Rxqf4=
Date: Tue, 8 Apr 2008 21:34:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: bootmem allocator
Message-ID: <20080408173418.GD7656@cvg>
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu> <87iqytqwl7.fsf@basil.nowhere.org> <20080408080446.GA12308@elte.hu> <20080408081206.GL16647@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408081206.GL16647@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andi Kleen - Tue, Apr 08, 2008 at 10:12:06AM +0200]
| On Tue, Apr 08, 2008 at 10:04:46AM +0200, Ingo Molnar wrote:
| > 
| > * Andi Kleen <andi@firstfloor.org> wrote:
| > 
| > > > hm, bootmem allocator is supposed to clear memory. We have a couple 
| > > > of places that rely on that.
| > > 
| > > I was actually considering to change that for the GB pages hugetlbfs 
| > > patchkit, because memset for 1G is a little slow and not needed (will 
| > > be cleared later anyways) and it might be a problem for very large 
| > > systems with a lot of such pages at boot.
| > 
| > changing the default behavior of bootmem alloc to be non-clearing is a 
| > really bad idea that will only cause unrobustness. The proper approach 
| > is to add an _opt-in_ API that does not clear memory 
| 
| I was considering that too, but we have so many weird variants of bootmem
| with opt in and opt out and even combinations of both now that the whole thing 
| is starting to look really pear shaped (I admit I added some of them
| in the past myself but I'm not proud). Would be a great project for
| someone to consolidate that all a bit.
| 
| -Andi
| 

Andi, could you a bit clarify what exactly do you mean?

		- Cyrill -
