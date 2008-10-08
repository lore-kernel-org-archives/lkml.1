Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbYJHIfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbYJHIfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 04:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYJHIfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 04:35:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48298 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751643AbYJHIfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 04:35:22 -0400
Date: Wed, 8 Oct 2008 09:34:24 +0100
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
Message-ID: <20081008093424.4e88a3c2@lxorguk.ukuu.org.uk>
In-Reply-To: <20081007235737.GD7971@one.firstfloor.org>
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
	<2f11576a0810070931k79eb72dfr838a96650563b93a@mail.gmail.com>
	<20081007211038.GQ20740@one.firstfloor.org>
	<20081008000518.13f48462@lxorguk.ukuu.org.uk>
	<20081007232059.GU20740@one.firstfloor.org>
	<20081008004030.7a0e9915@lxorguk.ukuu.org.uk>
	<20081007235737.GD7971@one.firstfloor.org>
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

Oh and as a PS you can also (for the hint case) do this:

	shmat giving an address
	if error
		shmat giving no address

from user space.

Alan
