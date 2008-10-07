Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYJGPE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYJGPE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYJGPEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:04:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57777 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbYJGPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:04:45 -0400
Date: Tue, 7 Oct 2008 17:10:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC, v2] shmat: introduce flag SHM_MAP_HINT
Message-ID: <20081007151049.GL20740@one.firstfloor.org>
References: <20081006192923.GJ3180@one.firstfloor.org> <1223362670-5187-1-git-send-email-kirill@shutemov.name> <20081007082030.GD20740@one.firstfloor.org> <20081007100854.GA5039@localhost.localdomain> <20081007112631.GH20740@one.firstfloor.org> <Pine.LNX.4.64.0810071532280.29910@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810071532280.29910@blonde.site>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 03:38:44PM +0100, Hugh Dickins wrote:
> On Tue, 7 Oct 2008, Andi Kleen wrote:
> > > I want say that we shouldn't do this check if shmaddr is a search hint.
> > > I'm not sure that check is unneeded if shmadd is the exact address.
> > 
> > mmap should fail in this case because it does the same check for 
> > MAP_FIXED. Obviously it cannot succeed when there is already something
> > else there.
> 
> I'm not really following this, so forgive me if I'm reading you
> out of context, but I think you're wrong on that...

You're right, Hugh, I was confused here. The earlier check
is indeed needed and cannot be dropped. Thanks for the reality check.

-Andi
