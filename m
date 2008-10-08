Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYJHMtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYJHMtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 08:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYJHMtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 08:49:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48660 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863AbYJHMtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:49:05 -0400
Date: Wed, 8 Oct 2008 13:46:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Message-ID: <20081008134604.27d3eb7a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081008110243.GN7971@one.firstfloor.org>
References: <20081007211038.GQ20740@one.firstfloor.org>
	<20081008000518.13f48462@lxorguk.ukuu.org.uk>
	<20081007232059.GU20740@one.firstfloor.org>
	<20081008004030.7a0e9915@lxorguk.ukuu.org.uk>
	<20081007235737.GD7971@one.firstfloor.org>
	<20081008093424.4e88a3c2@lxorguk.ukuu.org.uk>
	<20081008084350.GI7971@one.firstfloor.org>
	<20081008095851.01790b6a@lxorguk.ukuu.org.uk>
	<20081008091112.GK7971@one.firstfloor.org>
	<20081008112037.6fa37c0b@lxorguk.ukuu.org.uk>
	<20081008110243.GN7971@one.firstfloor.org>
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

> > kernel is not to provide nappies for people who think programming is too
> > hard but to provide services that can be used to build applications.
> 
> Outsourcing kernel locking to user space is not the way to go.

You mean like say flock, O_APPEND  ...

Putting stuff in user space is good, it means we don't carry tons of
never used app specific crap in the kernel, in every users kernel,
unpageable and basically unused.

Alan
