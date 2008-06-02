Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbYFBM2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbYFBM2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYFBM2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:28:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYFBM2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:28:39 -0400
Date: Mon, 2 Jun 2008 08:28:19 -0400
From: Alan Cox <alan@redhat.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>,
       Joe Peterson <joe@skyrush.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080602122819.GA25136@devserv.devel.redhat.com>
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de> <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core> <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core> <19f34abd0806020316v4135935dxff04bcf663ebd4bf@mail.gmail.com> <19f34abd0806020339m100fd3f8m6c0c6ff0c08a66d2@mail.gmail.com> <20080602105210.GH18697@devserv.devel.redhat.com> <19f34abd0806020357w6478704dt50226f51c6c62701@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806020357w6478704dt50226f51c6c62701@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 12:57:07PM +0200, Vegard Nossum wrote:
> I guess this still doesn't explain why TTOU doesn't block (IOW, stop
> the process, right?) in this case, because my test program does not
> touch it.

I see the parent process sleeping and the child taking TTOU and going to
state T. That again is correct.

alan      3219  0.0  0.0   3652   384 pts/5    S    13:11   0:00 ./repro
alan      3220  0.0  0.0   3652   204 pts/5    T    13:11   0:00 ./repro

If you run it without any straces etc do you see it blocked in T or sitting
in R ?

Alan


