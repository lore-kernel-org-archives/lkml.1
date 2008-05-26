Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbYEZO5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbYEZO5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYEZO45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:56:57 -0400
Received: from vena.lwn.net ([206.168.112.25]:45362 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbYEZO44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:56:56 -0400
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: drivers/char/dsp56k.c breakage [was: Re: linux-next: Tree for May 26] 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 26 May 2008 16:46:45 +0200."
             <Pine.LNX.4.64.0805261644230.4417@anakin> 
Date: Mon, 26 May 2008 08:56:55 -0600
Message-ID: <29942.1211813815@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> commit	6fe28df6c14e7e02bfea6b2bebf42716176e6dff
> 
>     dsp56k: BKL pushdown
> 
>     Put explicit lock_kernel calls into dsp56k_open().
> 
> Broke the build of drivers/char/dsp56k.c by introducing a jump to a
> non-existent label

Sigh.  Sorry about that.  I've recreated the tree without that dumb
mistake.

jon

Jonathan Corbet / LWN.net / corbet@lwn.net
