Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZGUDd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZGUDd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 23:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZGUDd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 23:33:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:58200 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbZGUDdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 23:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S7sYr/duVsCRqiNQjM86+/iGSq8AUGd59rLpw1wylawPXlDY/DrStUkyLJATjqw02A
         Mfzd6Cb5OTao08K5g0I8qJ+3YEN4POMjtHCKNEVNVhCeYbwuUHTa1y84yelFYx7P+NvN
         SElCl5bQKlo2N13lXNPJbMTljl2qWsLxAsYFw=
MIME-Version: 1.0
In-Reply-To: <a8e1da0907130108y18e56346paaa87e0779ddf743@mail.gmail.com>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
	 <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
	 <1246201486-7308-3-git-send-email-tom.leiming@gmail.com>
	 <1246201486-7308-4-git-send-email-tom.leiming@gmail.com>
	 <1246201486-7308-5-git-send-email-tom.leiming@gmail.com>
	 <20090713080205.GA2187@darkstar>
	 <a8e1da0907130108y18e56346paaa87e0779ddf743@mail.gmail.com>
Date: Tue, 21 Jul 2009 11:33:52 +0800
Message-ID: <d82e647a0907202033x58149baehad4883dddd338cf2@mail.gmail.com>
Subject: Re: [RESEND PATCH 04/11] kernel:lockdep:implement check_noncircular() 
	by BFS
From: Ming Lei <tom.leiming@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/13 Dave Young <hidave.darkstar@gmail.com>:
>>
>> Shouldn't be 'static noinline int' here? Same question to following ones.
>>
>
> Sorry for pointing to wrong place. please grep to find them:
>
> 161:+static int noinline print_bfs_bug(int ret)
> 173: static int noinline print_infinite_recursion_bug(void)

Since BFS removes recursion, many noinline may be not necessary.
Thanks.

-- 
Lei Ming
