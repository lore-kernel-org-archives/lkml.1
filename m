Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbZE1Ehx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbZE1Ehx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 00:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZE1Ehp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 00:37:45 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48502 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZE1Eho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 00:37:44 -0400
X-AuditID: b753bd60-ad649ba000006009-32-4a1e15189c34
Message-ID: <4A1E1512.1080603@hitachi.com>
Date: Thu, 28 May 2009 13:37:38 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] [0/16] POISON: Intro
References: <20090407509.382219156@firstfloor.org> 
    <4A1BE58A.9060708@hitachi.com> <20090526132914.GF846@one.firstfloor.org>
In-Reply-To: <20090526132914.GF846@one.firstfloor.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

> On Tue, May 26, 2009 at 09:50:18PM +0900, Hidehiro Kawai wrote:
> 
>>I believe people concerning high reliable system are expecting
>>this kind of functionality.
>>But I wonder why this patch set (including former MCE improvements
>>patches) has not been merged into any subsystem trees yet.
> 
>>What is the problem?  Because of the deadlock bug and the ref counter

> There was some work recently on fixing problems found in the
> hwpoison code during further review (me with Fengguang Wu). 
> I'm hoping to do a repost with all the fixes soon
> and then it's a mm candidate and hopefully ready for merge really soon.

Thank you, Andi.

>>If so, I'd like to try to narrow down the problems or review
>>patches (although I'm afraid I'm not so skillful).
> 
> Sure any review or additional testing is welcome.
> 
> I wanted to do full reposts this week anyways, so you
> can start from there again.

OK, I'll do that.
 
>>BTW, I looked over this patch set, and I couldn't
>>find any problems except for one minor point.  I'll post
>>a comment about it later.  It is very late, but better than nothing.
> 
> Great. Thanks. Can I add your Reviewed-by tags then?

Yes, of course.

Reviewed-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

