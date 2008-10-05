Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYJEMD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYJEMD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 08:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYJEMDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 08:03:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42759 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753006AbYJEMDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 08:03:48 -0400
Date: Sun, 5 Oct 2008 13:03:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kanru Chen <koster@debian.org.tw>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TIOCGWINSZ retuns old pty size after receiving SIGWINCH
Message-ID: <20081005130330.3cbb72d5@lxorguk.ukuu.org.uk>
In-Reply-To: <20081005113943.GA14320@atom>
References: <20081005113943.GA14320@atom>
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

On Sun, 5 Oct 2008 19:39:44 +0800
Kanru Chen <koster@debian.org.tw> wrote:

> Hi Alan,
> 
> Could you push a fix for this problem for .27 release? It seems many
> people encounter this if they compile with PREEMPT enabled and it's quite
> annoying.

The relevant fixes were pushed and are in the current -rc series kernels.
The tty mutex now locks the TIOCG/SWINSZ calls using the tty mutex lock
of the tty side of tty/pty pairs.

Alan
