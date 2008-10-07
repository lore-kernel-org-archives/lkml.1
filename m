Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYJGXGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYJGXGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbYJGXGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:06:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49685 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753390AbYJGXGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:06:44 -0400
Date: Wed, 8 Oct 2008 00:05:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Message-ID: <20081008000518.13f48462@lxorguk.ukuu.org.uk>
In-Reply-To: <20081007211038.GQ20740@one.firstfloor.org>
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
	<2f11576a0810070931k79eb72dfr838a96650563b93a@mail.gmail.com>
	<20081007211038.GQ20740@one.firstfloor.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008 23:10:38 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > Sorry, no.
> > This description still doesn't explain why this interface is needed.
> > 
> > The one of the points is this interface is used by another person or not.
> > You should explain how large this interface benefit has.
> > 
> > Andi kleen explained this interface _can_  be used another one.
> > but nobody explain who use it actually.
> 
> Anyone who doesn't want to use fixed addresses. 

Can use shm_open and mmap to get POSIX standard shm behaviour via a sane
interface without adding more crap to the sys3 shm madness. 

Sorry this patch is completely bogus - introduce the user programs
involved to 1990s technology. They have to be updated to use such a
change as is proposed anyway so they might as well use shm_open/mmap at
which point no kernel changes are needed.

Alan
