Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbYJGQ4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbYJGQ4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYJGQ4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:56:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36159 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753390AbYJGQ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:56:12 -0400
Date: Tue, 7 Oct 2008 17:54:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Message-ID: <20081007175412.0d88da30@lxorguk.ukuu.org.uk>
In-Reply-To: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
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

On Tue,  7 Oct 2008 19:15:17 +0300
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> If SHM_MAP_NOT_FIXED specified and shmaddr is not NULL, then the kernel takes
> shmaddr as a hint about where to place the mapping. The address of the mapping
> is returned as the result of the call.
> 
> It's similar to mmap() without MAP_FIXED.

NAK

This is a pointless API extension tacked onto a historic interface that
isn't well designed.

Use shm_open, and mmap and you get the functionality required using
modern posix interfaces with *NO* Linux extensions involved.

Alan
