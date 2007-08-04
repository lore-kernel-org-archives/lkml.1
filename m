Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbXHDVPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbXHDVPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 17:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762043AbXHDVO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 17:14:59 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:39030 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762004AbXHDVO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 17:14:58 -0400
Date: Sat, 4 Aug 2007 17:14:55 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Valerie Henson <val@nmt.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tulip-users@lists.sourceforge.net, david@lang.hm,
       Grant Grundler <grundler@parisc-linux.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH][RESEND] Semi-pointless NULL test in uli526x driver
Message-ID: <20070804211455.GC3530@fattire.cabal.ca>
References: <200708042032.12317.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708042032.12317.jesper.juhl@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 08:32:12PM +0200, Jesper Juhl wrote:
> I don't think dev_id can ever actually be NULL, so the whole block 
> inside "if (!dev) {" could probably just go away. But I guess 
> there's a good reason someone put that ULI526X_DBUG() in there - and
> if 'dev_id' /can/ actually be NULL then it's nice to have and in 
> that case this patch actually fixes a possible crash (hence the 
> version number update). 

It *can* be null, in the case of another handler being registered on the
same irq number, passing NULL for the cookie.

Ack. Will apply.

Regards,
	Kyle
