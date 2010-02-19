Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0BSKny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 05:43:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38404 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677Ab0BSKnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 05:43:53 -0500
Date: Fri, 19 Feb 2010 10:46:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: atrigent@ccs.neu.edu
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add a new VT mode which is like VT_PROCESS but doesn't
 require a VT_RELDISP ioctl call
Message-ID: <20100219104616.377927e6@lxorguk.ukuu.org.uk>
In-Reply-To: <2582583.137891266540487930.JavaMail.root@zimbra>
References: <8618245.137111266537413491.JavaMail.root@zimbra>
	<2582583.137891266540487930.JavaMail.root@zimbra>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the X server eventually uses this new mode, debugging and crash
> recovery should become easier. This is because even when currently in
> the VT of a frozen X server it would still be possible to switch out
> by doing SysRq-r and then CTRL-<number of a text vt>, sshing in and
> doing chvt <number of a text vt>, or any other method of VT switching.
> The general concensus on #xorg-devel seems to be that it should be
> safe to use this with X now that we have KMS.
> 
> Signed-off-by: Ari Entlich <atrigent@ccs.neu.edu>

If KMS doesn't need to mode switch then does it need any of this stuff -
can it not just switch to a console and use it ? Otherwise please use a
different value than ACKACQ (just for clarity) and conceptually it looks
fine to me - I just question if it's really needed as KMS based X not
having to play with magic locking stuff would be cleaner still.

Alan
