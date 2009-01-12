Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZALPxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZALPxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZALPwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:52:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38228 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751979AbZALPwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:52:54 -0500
Date: Mon, 12 Jan 2009 15:52:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090112155239.5f677a17@lxorguk.ukuu.org.uk>
In-Reply-To: <20090112155030.GA21063@ioremap.net>
References: <20090112153304.GA19995@ioremap.net>
	<20090112154922.6003750b@lxorguk.ukuu.org.uk>
	<20090112155030.GA21063@ioremap.net>
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

On Mon, 12 Jan 2009 18:50:30 +0300
Evgeniy Polyakov <zbr@ioremap.net> wrote:

> On Mon, Jan 12, 2009 at 03:49:22PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > > Do you want to own a tame killer? Do you want to control the world?
> > 
> > We've got /proc/*/oom_adj already
> 
> Which has to be checked for every process ever created,
> which is quite unfeasible in some conditions.

The task name is not a reliable indicator of true name and truncated so
is useless. You only nominate one task, you don't integrate with the
existing interface.

What you actually need is notifiers to work on /proc (exactly the same as
we need to avoid the bogus waitfd crap). At that point you can implement
arbitary policy by using dnotify/inotify/etc on /proc.

Alan
