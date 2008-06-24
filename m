Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbYFXVqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbYFXVqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbYFXVq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:46:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57260 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754118AbYFXVq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:46:28 -0400
Date: Tue, 24 Jun 2008 22:28:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: william <william@waisse.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: strange freeze with VIA C7 dedicated server and libc 2.6.1
Message-ID: <20080624222859.1e12dc2d@lxorguk.ukuu.org.uk>
In-Reply-To: <2ffbcf00806241405w5b757b56p84cd560166ea8f90@mail.gmail.com>
References: <2ffbcf00806232001o4bd314f4kc590e43b4ab27076@mail.gmail.com>
	<20080624102129.19d79eb0@lxorguk.ukuu.org.uk>
	<2ffbcf00806241405w5b757b56p84cd560166ea8f90@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * the watchdog says nothing in the logs, but is able to reboot the box.
> 
>  Thank you very much for your answer Alan, I were hesitating on
> posting a report with no logs, no clues . . . your answer gives me a
> little hope ;)

Two random thoughts from your last comment

- If you do

echo "2" >/proc/sys/vm/overcommit_memory
echo "80" >/proc/sys/vm/overcommit_ratio

do you instead get out of memory kills (which would imply bad memory
leaks perhaps triggered by glibc ?)

- Does your system pass 'crashme' testing (run as a non root user). If
not then that might give an eventual identification of a crashme run
which takes out the box. We've found kernel bugs, CPU bugs and
combinations of the two before now that way.
