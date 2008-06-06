Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbYFFVdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbYFFVdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbYFFVc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:32:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55940 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbYFFVc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:32:58 -0400
Subject: Re: [patch 0/7] speculative page references, lockless pagecache,
	lockless gup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: npiggin@suse.de
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
In-Reply-To: <20080605094300.295184000@nick.local0.net>
References: <20080605094300.295184000@nick.local0.net>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 23:32:44 +0200
Message-Id: <1212787964.19205.74.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 19:43 +1000, npiggin@suse.de wrote:
> Hi,
> 
> I've decided to submit the speculative page references patch to get merged.
> I think I've now got enough reasons to get it merged. Well... I always
> thought I did, I just didn't think anyone else thought I did. If you know
> what I mean.
> 
> cc'ing the powerpc guys specifically because everyone else who probably
> cares should be on linux-mm...
> 
> So speculative page references are required to support lockless pagecache and
> lockless get_user_pages (on architectures that can't use the x86 trick). Other
> uses for speculative page references could also pop up, it is a pretty useful
> concept. Doesn't need to be pagecache pages either.

For patches 1-5

Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

