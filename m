Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYJHKY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYJHKY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 06:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbYJHKWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 06:22:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52889 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754158AbYJHKWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:22:38 -0400
Date: Wed, 8 Oct 2008 11:20:37 +0100
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
Message-ID: <20081008112037.6fa37c0b@lxorguk.ukuu.org.uk>
In-Reply-To: <20081008091112.GK7971@one.firstfloor.org>
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
	<2f11576a0810070931k79eb72dfr838a96650563b93a@mail.gmail.com>
	<20081007211038.GQ20740@one.firstfloor.org>
	<20081008000518.13f48462@lxorguk.ukuu.org.uk>
	<20081007232059.GU20740@one.firstfloor.org>
	<20081008004030.7a0e9915@lxorguk.ukuu.org.uk>
	<20081007235737.GD7971@one.firstfloor.org>
	<20081008093424.4e88a3c2@lxorguk.ukuu.org.uk>
	<20081008084350.GI7971@one.firstfloor.org>
	<20081008095851.01790b6a@lxorguk.ukuu.org.uk>
	<20081008091112.GK7971@one.firstfloor.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That is racy when multi threaded because shmat() doesn't replace, so you 
> would need to munmap() inbetween and someone else could steal the area
> then. Yes you could stick a loop around it. It could livelock.
> No, it's not a good interface I would advocate.

You could just use pthread mutexes in your application. The rôle of the
kernel is not to provide nappies for people who think programming is too
hard but to provide services that can be used to build applications.

Alan
