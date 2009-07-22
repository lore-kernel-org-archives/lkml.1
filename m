Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZGVNKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZGVNKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZGVNKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:10:53 -0400
Received: from mail-pz0-f180.google.com ([209.85.222.180]:41279 "EHLO
	mail-pz0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbZGVNKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PHbQMSP1B1MxQpkjwZYE3nhmEx9/K0ab6xk6t88J8qCKMO0sHytD/gEjRywZkNpjzd
         ZLL06/MMvZ+OoleNjq3kszzlmcMGdQI3UloB7ODH0i7r71CsQ6Rbj9Fs4RACszL/N58u
         2wv5/l/iYQsLFqk8RtCJYwTN9vW4C2NIvIoEA=
MIME-Version: 1.0
In-Reply-To: <1248267830.27058.1404.camel@twins>
References: <1248267513-4934-1-git-send-email-tom.leiming@gmail.com>
	 <1248267513-4934-2-git-send-email-tom.leiming@gmail.com>
	 <1248267513-4934-3-git-send-email-tom.leiming@gmail.com>
	 <1248267830.27058.1404.camel@twins>
Date: Wed, 22 Jul 2009 21:10:53 +0800
Message-ID: <d82e647a0907220610i484b8d57q39a0141579669b58@mail.gmail.com>
Subject: Re: [tip:core/locking 2/3] lockdep:define preallocated "stack" for 
	BFS as per cpu variable
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/22 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Wed, 2009-07-22 at 20:58 +0800, tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>
> This patch can use a changelog.
>
> Why is this needed, isn't all that serialized by the graph_lock anyway?
> Or are there a few paths where this isn't the case and we're now racy?

It is really serialized by the graph_lock, but we can prevent cpu cache from
being flushing by different cpu access,  which seems that can be avoided by
per cpu variables. Right?

Thanks.

-- 
Lei Ming
