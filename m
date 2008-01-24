Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYAXANH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYAXANH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYAXAMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:12:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbYAXAMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:12:54 -0500
Date: Wed, 23 Jan 2008 16:11:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: a.p.zijlstra@chello.nl, salikhmetov@gmail.com, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
Subject: Re: [PATCH -v8 3/4] Enable the MS_ASYNC functionality in
 sys_msync()
In-Reply-To: <E1JHpaa-0004a9-8B@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.00.0801231610220.2803@woody.linux-foundation.org>
References: <12010440803930-git-send-email-salikhmetov@gmail.com>  <1201044083504-git-send-email-salikhmetov@gmail.com>  <alpine.LFD.1.00.0801230836250.1741@woody.linux-foundation.org> <1201110066.6341.65.camel@lappy> <alpine.LFD.1.00.0801231107520.1741@woody.linux-foundation.org>
 <E1JHlh8-0003s8-Bb@pomaz-ex.szeredi.hu> <alpine.LFD.1.00.0801231248060.2803@woody.linux-foundation.org> <E1JHmxa-0004BK-6X@pomaz-ex.szeredi.hu> <alpine.LFD.1.00.0801231329120.2803@woody.linux-foundation.org> <E1JHpaa-0004a9-8B@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Jan 2008, Miklos Szeredi wrote:
> 
> But I still think this approach should work.  Untested, might eat your
> children, so please don't apply to any kernel.

Yes, something like that should work.

The important part is to not do the "TestClearPageDirty()" separately, the 
rest of it can be done well enough.

		Linus
