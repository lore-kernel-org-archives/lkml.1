Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYIVWMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYIVWMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYIVWMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:12:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44457 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753063AbYIVWMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:12:43 -0400
Date: Mon, 22 Sep 2008 23:12:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH] pcmcia: Fix broken abuse of dev->driver_data
Message-ID: <20080922231227.2625dd09@lxorguk.ukuu.org.uk>
In-Reply-To: <20080922215617.GA13057@comet.dominikbrodowski.net>
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk>
	<20080922215617.GA13057@comet.dominikbrodowski.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	
> 
> trailing whitespace

Nod..

> >  	if (did && (did->match_flags & PCMCIA_DEV_ID_MATCH_DEVICE_NO) &&
> >  	    (p_dev->socket->device_count == 1) && (p_dev->device_no ==
> > 0)) pcmcia_add_device_later(p_dev->socket, 0);
> 
> uh?

Looks like a mailer folded it later, but the patch itself seems just fine.

> >  
> > - put_module:
> > +put_module:
> >  	if (ret)
> >  		module_put(p_drv->owner);
> > - put_dev:
> > +put_dev:
> 
> unrelated -- please do not change it this time.

Not sure you can have it both ways - if you don't want stray whitespace
then fixing the labels to conform to coding style seems to go with it ;)

Alan
