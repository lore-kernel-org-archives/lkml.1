Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYFXJjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYFXJjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYFXJjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:39:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47091 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751328AbYFXJjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:39:01 -0400
Date: Tue, 24 Jun 2008 10:21:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: william <william@waisse.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: strange freeze with VIA C7 dedicated server and libc 2.6.1
Message-ID: <20080624102129.19d79eb0@lxorguk.ukuu.org.uk>
In-Reply-To: <2ffbcf00806232001o4bd314f4kc590e43b4ab27076@mail.gmail.com>
References: <2ffbcf00806232001o4bd314f4kc590e43b4ab27076@mail.gmail.com>
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

> "If the kernel completely locks up then that is a kernel bug or a hardware bug.
> It shouldn't be possible to lock up the kernel, regardless of what userland
> such as glibc does. Presumably the newer glibc is doing something different

Except for bugs in glibc that trigger things happening as root which go
on to do stuff like power down the system (root is allowed to power
down/reboot/etc). That is a fairly unlikely case.

> that is triggering the bug. Regardless of what that is and whether it should be
> doing it, it shouldn't completely hang the kernel."

The first thing is to find out which glibc version is the latest that
works, which is the earliest that fails. Second is to try and find out
what apps or event is the trigger for the fail (eg can you boot into text
mode with init s and then run 2 or 3 cpu hogs all day)

Alan
