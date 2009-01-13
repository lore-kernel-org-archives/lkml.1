Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZAMM1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZAMM1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZAMM1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:27:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34353 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753267AbZAMM1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:27:05 -0500
Date: Tue, 13 Jan 2009 12:27:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       greg@kroah.com
Subject: Re: ANDROID low memory killer register (was Linux killed Kenny,
 bastard!)
Message-ID: <20090113122722.205605cf@lxorguk.ukuu.org.uk>
In-Reply-To: <20090113122356.GB25011@ioremap.net>
References: <496C73DE.3030600@wpkg.org>
	<20090113121038.3410de28@lxorguk.ukuu.org.uk>
	<20090113122356.GB25011@ioremap.net>
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

On Tue, 13 Jan 2009 15:23:56 +0300
Evgeniy Polyakov <zbr@ioremap.net> wrote:

> On Tue, Jan 13, 2009 at 12:10:38PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > I believe they are related in the sense that both of them are
> > unneccessary and should not make the final kernel...
> > 
> > The /proc../oom_adj interface is again sufficient for this.
> 
> Besides the fact that it will unlikely to work the way you expect, since
> oom adjustment is racy and may be too late, or not happend at all...

I would love to see a proposal that met such criteria. I don't think I
ever will and your random name based hack isn't it. The closest we have
right now is the container stuff.

Alan
