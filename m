Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbYETI7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbYETI7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbYETI6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:58:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36836 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758645AbYETI6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:58:54 -0400
Date: Tue, 20 May 2008 09:46:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3, RFC] misc char dev BKL pushdown
Message-ID: <20080520094604.5efc323e@core>
In-Reply-To: <200805200126.29738.arnd@arndb.de>
References: <13762.1211142411@vena.lwn.net>
	<200805200107.51659.arnd@arndb.de>
	<200805200126.29738.arnd@arndb.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 01:26:28 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> The Big Kernel Lock has been pushed down from chardev_open
> to misc_open, this change moves it to the individual misc
> driver open functions.
> 
> As before, the change was purely mechanical, most drivers
> should actually not need the BKL. In particular, we still
> hold the misc_mtx() while calling the open() function
> The patch should probably be split into one changeset
> per driver.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Alan Cox <alan@redhat.com>
