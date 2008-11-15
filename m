Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbYKOUbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbYKOUbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 15:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYKOUbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 15:31:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42579 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751518AbYKOUbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 15:31:09 -0500
Date: Sat, 15 Nov 2008 20:30:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patch] libata fix
Message-ID: <20081115203036.47da5548@lxorguk.ukuu.org.uk>
In-Reply-To: <20081114235640.GA3624@havoc.gtf.org>
References: <20081114235640.GA3624@havoc.gtf.org>
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

> Tejun Heo (1):
>       libata: improve phantom device detection
> 

This seems highly inappropriate for 2.6.28

It fixes a case where people get a slow boot. It risks users suddenely
finding some devices and controllers don't detect drives at all. Some are
very quirky on device probe - eg the IT821x in RAID mode.

This could be tested in -next/-mm/2.6.29-rc and backported without much
pain.
