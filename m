Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbXLaQqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbXLaQqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbXLaQqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:46:32 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37738 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905AbXLaQqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:46:31 -0500
Date: Mon, 31 Dec 2007 16:38:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: "Michael Buesch" <mb@bu3sch.de>, "Adrian Bunk" <bunk@kernel.org>,
       "Bodo Eggert" <7eggert@gmx.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>, devzero@web.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
Message-ID: <20071231163803.33acb647@the-village.bc.nu>
In-Reply-To: <64bb37e0712310817g621d818dyebbf2228063d4d5f@mail.gmail.com>
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz>
	<20071231144255.GB13803@does.not.exist>
	<64bb37e0712310755k2446e67eq81d31cd476eb75e3@mail.gmail.com>
	<200712311659.14847.mb@bu3sch.de>
	<20071231160140.579f0fb2@the-village.bc.nu>
	<64bb37e0712310817g621d818dyebbf2228063d4d5f@mail.gmail.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Dec 2007 17:17:19 +0100
"Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> a) this could be disabled during development if you want this
> b) this would even only affect development if you add new code that
> now needs a EXPORT_SYMBOL that was removed on an earlier build. And
> right now this would also need to trigger a rerun of depmod. And the
> same trigger could redo this garbage collect.
> 
> Or am I missing something obvious?

Development is not a phase seperate from use or distribution. A lot of
module testers for distributions will not be compiling their own modules
but loading in ones to test provided by their vendor - which may of
course then need different ksyms

Alan
