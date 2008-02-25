Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYBYSdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYBYSdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYBYSdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:33:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57846 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755393AbYBYSdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:33:05 -0500
Date: Mon, 25 Feb 2008 18:19:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
Message-ID: <20080225181957.4eeed15d@core>
In-Reply-To: <47C3078E.3000008@redhat.com>
References: <30804.1203962369@turing-police.cc.vt.edu>
	<47C3078E.3000008@redhat.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The reason I added GPL is not because of some idea that this is all 
> "chummy" with the kernel. But because I derived the mcount code from 
> glibc's version of mcount. Now you may argue that glibc is under LGPL 
> and a non-GPL export is fine. But I've been advised that if I ever take 
> code from someone else, to always export it with GPL.

As I understand it if Vladis wants to submit his own change to the symbol
thats up to him, and he'll be liable for any fallout with the FSF, or
harm to Linux resulting, so long he's the one who signs it off.

If its FSF code perhaps it would be polite for Vladis to ask the FSF
first if he wants to do it nicely.

Alan
