Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbZGVNpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbZGVNpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZGVNpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:45:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:14763 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZGVNpC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:45:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AqhVyrcIm7H8t0r/7ucQ+XVfIG7KfeCR+n4L1zhEWpDePH4QYkHB3Axb89G4amwZfi
         /lXrge52Cz170sX6Fo3N8H0YnUlaR6LqELQ5/8PjJz9ne6gxbnUkMmCbsazO+19jgoVf
         BQ/peg/SJAg/Bw9S+NT0ikzvDa9/ek1Gq6L+4=
MIME-Version: 1.0
In-Reply-To: <1248268755.27058.1426.camel@twins>
References: <1248267513-4934-1-git-send-email-tom.leiming@gmail.com>
	 <1248267513-4934-2-git-send-email-tom.leiming@gmail.com>
	 <1248267513-4934-3-git-send-email-tom.leiming@gmail.com>
	 <1248267830.27058.1404.camel@twins>
	 <d82e647a0907220610i484b8d57q39a0141579669b58@mail.gmail.com>
	 <1248268755.27058.1426.camel@twins>
Date: Wed, 22 Jul 2009 21:45:02 +0800
Message-ID: <d82e647a0907220645s109f487fva6d68a9abea68372@mail.gmail.com>
Subject: Re: [tip:core/locking 2/3] lockdep:define preallocated "stack" for 
	BFS as per cpu variable
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/22 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Wed, 2009-07-22 at 21:10 +0800, Ming Lei wrote:
>> 2009/7/22 Peter Zijlstra <a.p.zijlstra@chello.nl>:
>> > On Wed, 2009-07-22 at 20:58 +0800, tom.leiming@gmail.com wrote:
>> >> From: Ming Lei <tom.leiming@gmail.com>
>> >
>> > This patch can use a changelog.
>> >
>> > Why is this needed, isn't all that serialized by the graph_lock anyway?
>> > Or are there a few paths where this isn't the case and we're now racy?
>>
>> It is really serialized by the graph_lock, but we can prevent cpu cache from
>> being flushing by different cpu access,  which seems that can be avoided by
>> per cpu variables. Right?
>
> I doubt it'll make a difference, got any numbers to back that up?

OK, I'll design some test case to get the numbers.

Thanks.


-- 
Lei Ming
