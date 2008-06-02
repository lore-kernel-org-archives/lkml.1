Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYFBJgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYFBJgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYFBJgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:36:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55950 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750986AbYFBJgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:36:14 -0400
Date: Mon, 2 Jun 2008 10:20:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Willy Tarreau <w@1wt.eu>, Harald Dunkel <harald.dunkel@t-online.de>,
       Joe Peterson <joe@skyrush.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080602102033.63e4cd18@core>
In-Reply-To: <4843B6EE.8080104@davidnewall.com>
References: <48434D57.6030801@skyrush.com>
	<48438126.3080308@t-online.de>
	<20080602053256.GF5609@1wt.eu>
	<20080602091016.571dda7c@core>
	<4843B6EE.8080104@davidnewall.com>
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

On Mon, 02 Jun 2008 18:31:34 +0930
David Newall <davidn@davidnewall.com> wrote:

> Alan Cox wrote:
> > Not really. The task would get suspended if it attempted to change the
> > tty settings while not being session leader. This is part of the POSIX
> > and BSD job control.
> 
> I haven't heard about this new restriction, but it begs the observation
> that stty, when forked from a shell (the usual case), is never a session
> leader.

Sorry I mean part of the current session. I was thinking about the
specific case of bash or the ssh->bash setup where the question would be
whether the shell was session leader.

Someone who can dup this needs to instrument it in tty_ioctl really.

Alan
