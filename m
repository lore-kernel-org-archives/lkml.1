Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYJJJUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYJJJUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYJJJT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:19:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44326 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751479AbYJJJT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:19:57 -0400
Date: Fri, 10 Oct 2008 10:19:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: Better timeout recovery
Message-ID: <20081010101941.5822926e@lxorguk.ukuu.org.uk>
In-Reply-To: <87od1set2a.fsf@denkblock.local>
References: <20081009164351.26205.50193.stgit@localhost.localdomain>
	<87od1set2a.fsf@denkblock.local>
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

> I'd very much prefer comments to be formatted like this:

Would you... ;)

> > +	/* Can become DEBUG later */
> > +	if (count)
> > +		ata_port_printk(ap, KERN_WARNING,
> > +			"drained %d bytes to clear DRQ.\n", count);
> > +
> > +}
> 
> Presumably, you didn't intentionally leave a blank line before the
> closing brace.

Yes I did, it looked cleaner.

> Sorry if you were aware of all that and just sent the patch as a first
> draft in order to get comments on the actual code.

At the moment the main concern is the code quality - but you are right
I've not run the result through the style checker and probably should do
so.
