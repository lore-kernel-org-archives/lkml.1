Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbYETInp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbYETInp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYETInh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:43:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41898 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752031AbYETIng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:43:36 -0400
Date: Tue, 20 May 2008 09:31:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Aristeu Rozanski <aris@ruivo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] Implment a tty port structure and supporting
 logic
Message-ID: <20080520093127.3a07d6fa@core>
In-Reply-To: <20080519223943.GA8168@cathedrallabs.org>
References: <20080519144557.19326.74313.stgit@core>
	<20080519223943.GA8168@cathedrallabs.org>
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

On Mon, 19 May 2008 18:39:43 -0400
Aristeu Rozanski <aris@ruivo.org> wrote:

> Alan,
> > Right now each tty has its own port level structure which means we can share
> > no code between ports. Introduce a structure and some initial minor helper
> > routines so that we can move towards commonality. In doing this the USB serial
> > code gets a bit of shake up as it kept using port->tty unsafely. Fixing that
> > means changing the API of all the USB serial drivers. On the bright side the
> > API now looks far more like the tty layer API which will become useful later
> > on.
> do you have your tty/serial rework tree available in some server?

Not currently. Its on my todo list to sort that out hence testign stuff
like stgit at the moment.

Alan
