Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYHIVxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYHIVxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYHIVxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:53:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59132 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752122AbYHIVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:53:10 -0400
Date: Sat, 9 Aug 2008 22:35:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Wim Van Sebroeck <wim@iguana.be>, Ingo Molnar <mingo@redhat.com>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] WATCHDOG: don't auto-grab eurotechwdt.
Message-ID: <20080809223512.3c855bae@lxorguk.ukuu.org.uk>
In-Reply-To: <489E0F5A.8010404@keyaccess.nl>
References: <489E0F5A.8010404@keyaccess.nl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Aug 2008 23:42:50 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> [ Andrew: not submitted ]
> 
> Hi Wim.
> 
> I'm going over a list of drivers that break the boot of randconfig 
> kernels by keeping resources busy:

NAK this one. Same reason - if its a module the auto-grab should be
enabled. 
