Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbYFWO2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbYFWO2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbYFWO2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:28:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57933 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754047AbYFWO2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:28:40 -0400
Date: Mon, 23 Jun 2008 15:11:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Louis.Rilling@kerlabs.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/70] tty: Ldisc revamp
Message-ID: <20080623151112.30d840df@lxorguk.ukuu.org.uk>
In-Reply-To: <20080623133912.GU30804@localhost>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
	<20080620195801.1479.24228.stgit@localhost.localdomain>
	<20080623133912.GU30804@localhost>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > - *	This can be called by the "eventd" kernel thread.  That is process
> > +k *	This can be called by the "eventd" kernel thread.  That is process
> >   *	synchronous but doesn't hold any locks, so we need to make sure we
> >   *	have the appropriate locks for what we're doing.
> >   *
> 
> Sorry for such a trivial comment, but the leading 'k' above looks like a typo.

Thanks. I'll swat that in a follow up patch. Well spotted
