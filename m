Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbXJJP7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbXJJP7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 11:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbXJJP7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 11:59:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbXJJP7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 11:59:33 -0400
Date: Wed, 10 Oct 2007 11:59:20 -0400
From: Alan Cox <alan@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>, video4linux-list@redhat.com,
       Jiri Slaby <jirislaby@gmail.com>, daniel@qanu.de,
       linux-kernel@vger.kernel.org, holger@qanu.de,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 3/3] V4L: cinergyT2, remove bad usage of ERESTARTSYS
Message-ID: <20071010155920.GC22618@devserv.devel.redhat.com>
References: <24841282012868130110@pripojeni.net> <1191979260.5492.32.camel@gaivota> <470C5294.8060502@linuxtv.org> <1192030541.5896.54.camel@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1192030541.5896.54.camel@gaivota>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 12:35:41PM -0300, Mauro Carvalho Chehab wrote:
> Em Qua, 2007-10-10 às 00:18 -0400, Michael Krufky escreveu:
> > 
> > Is this illegal as per kernel codingstyle?
> 
> Yes, it is. CodingStyle states:

<rant>
No.. "Illegal" means prohibited by law. Its merely wrong 8)
</rant>

> The proper fix is just to replace the offended code by this:
> 
> err=foo();
> if (error)
> 	goto error;

Lots of code uses

	if ((err = foo()) < 0)

so I would'y worry too much. The split one however clearer and also
safer.

