Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbZGPEjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbZGPEjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbZGPEjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:39:08 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:43670 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbZGPEjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IbOjhAII+RQFIO3y29nGL+wl5DdP5DF3KpeMusGMcZvzgdR22nfQNPslEaagbhlTga
         1slk6lBrLdZvsH1g5EadzMkafuW3zWUlruvEl1rGU27A632rK+RdXRuQ3Edy4hLPM+G9
         JtsAqr80Ha9nPp2G1iy6T+tEatEt3WJKS1azc=
MIME-Version: 1.0
In-Reply-To: <1247476574.7529.55.camel@twins>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
	 <1247476574.7529.55.camel@twins>
Date: Thu, 16 Jul 2009 12:39:06 +0800
Message-ID: <d82e647a0907152139x12edd66agde44f155fa60506b@mail.gmail.com>
Subject: Re: [RESEND PATCH 0/11] kernel:lockdep:replace DFS with BFS
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/13 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Sun, 2009-06-28 at 23:04 +0800, tom.leiming@gmail.com wrote:
>> Hi,Peter
>>
>> Currently lockdep uses recursion DFS(depth-first search) algorithm to
>> search target in checking lock circle(check_noncircular()),irq-safe
>> -> irq-unsafe(check_irq_usage()) and irq inversion when adding a new
>> lock dependency. This patches replace the current DFS with BFS, based on
>> the following consideration:
>>
>>     1,no loss of efficiency, no matter DFS or BFS, the running time
>>     are O(V+E) (V is vertex count, and E is edge count of one
>>     graph);
>
> I'd still like to get some feedback on the loss of that generation count
> optimization done by DaveM, I haven't had time to analyze the
> ramifications of that.
>
>

Hi, Ingo and Peter

As you said, BFS patch-set is valuable(decrease kernel stack consume
largely, and report
the shortest circle).

It has been pending on lkml silently for several monthes, and I hope
it may be merged to
tip-tree or other tree. I don't know what we should and can do to make
it being accepted by tip-tree.
Anyway, I'd like to do any fixes for it to be merged.

Any suggestions, ideas or objections?

Thanks.

-- 
Lei Ming
