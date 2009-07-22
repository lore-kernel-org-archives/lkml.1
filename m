Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbZGVNSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbZGVNSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZGVNSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:18:06 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:20580 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbZGVNSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:18:04 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:core/locking 2/3] lockdep:define preallocated "stack" for
  BFS as per cpu variable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org
In-Reply-To: <d82e647a0907220610i484b8d57q39a0141579669b58@mail.gmail.com>
References: <1248267513-4934-1-git-send-email-tom.leiming@gmail.com>
	 <1248267513-4934-2-git-send-email-tom.leiming@gmail.com>
	 <1248267513-4934-3-git-send-email-tom.leiming@gmail.com>
	 <1248267830.27058.1404.camel@twins>
	 <d82e647a0907220610i484b8d57q39a0141579669b58@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 15:19:15 +0200
Message-Id: <1248268755.27058.1426.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 21:10 +0800, Ming Lei wrote:
> 2009/7/22 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > On Wed, 2009-07-22 at 20:58 +0800, tom.leiming@gmail.com wrote:
> >> From: Ming Lei <tom.leiming@gmail.com>
> >
> > This patch can use a changelog.
> >
> > Why is this needed, isn't all that serialized by the graph_lock anyway?
> > Or are there a few paths where this isn't the case and we're now racy?
> 
> It is really serialized by the graph_lock, but we can prevent cpu cache from
> being flushing by different cpu access,  which seems that can be avoided by
> per cpu variables. Right?

I doubt it'll make a difference, got any numbers to back that up?

