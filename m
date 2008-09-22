Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYIVW1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYIVW1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbYIVW05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:26:57 -0400
Received: from isilmar.linta.de ([213.133.102.198]:41457 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753145AbYIVW04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:26:56 -0400
Date: Tue, 23 Sep 2008 00:26:55 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcmcia: Fix broken abuse of dev->driver_data
Message-ID: <20080922222655.GA3792@isilmar.linta.de>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk> <20080922215617.GA13057@comet.dominikbrodowski.net> <20080922231227.2625dd09@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922231227.2625dd09@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 11:12:27PM +0100, Alan Cox wrote:
> Nod..
...
> Looks like a mailer folded it later, but the patch itself seems just fine.

*gnah* already applied upstream, including the comment implying that PCMCIA
driver's making use of driver_data were correct, while they were not. At
least the trailing whitespace didn't get merged.

> > >  
> > > - put_module:
> > > +put_module:
> > >  	if (ret)
> > >  		module_put(p_drv->owner);
> > > - put_dev:
> > > +put_dev:
> > 
> > unrelated -- please do not change it this time.
> 
> Not sure you can have it both ways - if you don't want stray whitespace
> then fixing the labels to conform to coding style seems to go with it ;)

Well, there's a difference, and I know you know that I know that you know ;)
but you should also know that I already tried to apply the patch as it is,
which implies that I do not object too strongly to the removal of these two
non-characters from ds.c ;)

Thanks,
	Dominik
