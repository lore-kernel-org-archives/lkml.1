Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbXE3S2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbXE3S2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 14:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXE3S2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 14:28:45 -0400
Received: from posti5.jyu.fi ([130.234.4.34]:37052 "EHLO posti5.jyu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbXE3S2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 14:28:45 -0400
Date: Wed, 30 May 2007 21:27:32 +0300 (EEST)
From: Tero Roponen <teanropo@jyu.fi>
X-X-Sender: teanropo@jalava.cc.jyu.fi
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: tty-related oops in latest kernel(s)?
In-Reply-To: <465DBEBD.7000205@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0705302127050.6489@jalava.cc.jyu.fi>
References: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi>
 <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
 <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com>
 <Pine.LNX.4.64.0705291900001.32656@jalava.cc.jyu.fi>
 <84144f020705291157k465ec6c4sb81081844bb57514@mail.gmail.com>
 <Pine.LNX.4.64.0705300654493.5241@jalava.cc.jyu.fi>
 <84144f020705292254o319f6619m787bf29491c92509@mail.gmail.com>
 <Pine.LNX.4.64.0705301458400.4634@jalava.cc.jyu.fi>
 <20070530083953.9909bcef.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705301857370.29485@jalava.cc.jyu.fi> <465DBEBD.7000205@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Pekka Enberg wrote:

> Tero Roponen wrote:
> > after some trial and error I found a simple way to trigger the
> > corruption:
> 
> Nice. This triggers on the file corruption on 2.6.21.3 also?
>

Yes:

[root@terrop ~]# init
Usage: init 0123456SsQqAaBbCcUu
[root@terrop ~]# ./oops
[root@terrop ~]# init
init: error while loading shared libraries: unexpected PLT reloc type 0xcc

-- 
Tero Roponen
