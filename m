Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYJGMd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYJGMd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 08:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYJGMdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 08:33:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44633 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752474AbYJGMdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 08:33:21 -0400
Date: Tue, 7 Oct 2008 13:31:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] shmat: introduce flag SHM_MAP_HINT
Message-ID: <20081007133132.69f69cc0@lxorguk.ukuu.org.uk>
In-Reply-To: <20081007112418.GC5126@localhost.localdomain>
References: <20081006132651.GG3180@one.firstfloor.org>
	<1223303879-5555-1-git-send-email-kirill@shutemov.name>
	<20081007195837.5A6B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081007112418.GC5126@localhost.localdomain>
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

> > Honestly, I don't like that qemu specific feature insert into shmem core.
> > At least, this patch is too few comments.
> > Therefore, an develpper can't understand why SHM_MAP_HINT exist.
> > 
> > I think this patch description is too short and too poor.
> > I don't like increasing mysterious interface.
> 
> Sorry for it. I'll fix it in next patch version.

I also don't see the point of this interface. We have POSIX shared memory
objects in Linux which are much cleaner and neater. They support mmap()
and mmap supports address hints.

There seems to be no reason at all to add further hacks to the historical
ugly SYS5 interface.

Alan
