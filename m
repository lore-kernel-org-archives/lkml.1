Return-Path: <linux-kernel-owner+w=401wt.eu-S1763465AbYESUAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465AbYESUAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763272AbYESUAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:00:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43052 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763242AbYESUAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:00:36 -0400
Date: Mon, 19 May 2008 20:48:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH 01/20] tty: Introduce a tty_port common structure
Message-ID: <20080519204804.1b21c0e7@core>
In-Reply-To: <20080519175121.GA25150@kroah.com>
References: <20080519144557.19326.74313.stgit@core>
	<20080519145013.19326.38344.stgit@core>
	<20080519174738.GA20961@uranus.ravnborg.org>
	<20080519175121.GA25150@kroah.com>
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

On Mon, 19 May 2008 10:51:21 -0700
Greg KH <greg@kroah.com> wrote:

> On Mon, May 19, 2008 at 07:47:39PM +0200, Sam Ravnborg wrote:
> > Hi Alan.
> > 
> > On Mon, May 19, 2008 at 03:50:13PM +0100, Alan Cox wrote:
> I'll run them through checkpatch.pl and fix up any minor things like
> this before sending them off, that's part of my normal patch-queue
> process :)

Please do *NOT* do that. It messes up resolving them against pending and
further patches that are not upstream. If you insist on doing that then I
will submit the patches myself via a different tree which does not.

By all means report cases where checkpatch isn't clean on them and send
me diffs to go back via my devel tree however.

Alan
