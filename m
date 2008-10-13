Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbYJMJYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbYJMJYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbYJMJYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:24:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49993 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754833AbYJMJYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:24:07 -0400
Date: Mon, 13 Oct 2008 10:23:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: GIT head no longer boots on x86-64
Message-ID: <20081013102330.46066092@lxorguk.ukuu.org.uk>
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

The boot ends on the first module load with a crash

	BUG: mm/vmalloc.c 118

From
	text_poke
	alternatives_smp_unlock
	alternatives_smp_module_add
	module_finalize
	load_module

while loading the EHCI driver

