Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbXGBR0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbXGBR0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 13:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbXGBR0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 13:26:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:26280 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbXGBR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 13:26:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JrkmjBrUSOL82lGQ9WZUx53P7hNi1iib3WKA1ga7dbo4IcTC62F0OIUAqP+DHjQNXKN/iAmb3lFczuOwOze/c96YDeyse0T9cToQn/X2xnkHSNSC6CosRBpXaCexNUACukLYdxcwC1B+vWIs/Dx4GzNjdc50hCphX725wXtp35Q=
Message-ID: <6934efce0707021026wad68bbar2d239d0cb7954ea0@mail.gmail.com>
Date: Mon, 2 Jul 2007 10:26:13 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: vm/fs meetup in september?
Cc: peter@chubb.wattle.id.au, "Christoph Hellwig" <hch@infradead.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200706301758.16607.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070624042345.GB20033@wotan.suse.de>
	 <20070630093243.GD22354@infradead.org>
	 <87bqexiwu3.wl%peter@chubb.wattle.id.au>
	 <200706301758.16607.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Christoph> So what you mean is "swap on flash" ?  Defintively sounds
> > Christoph> like an interesting topic, although I'm not too sure it's
> > Christoph> all that filesystem-related.
>
> I wouldn't want to call it swap, as this carries with it block-io
> connotations.  It's really mmap on flash.

Yes it is really mmap on flash.  But you are "swapping" pages from RAM
to be mmap'ed on flash.  Also the flash-io complexities are similar to
the block-io layer.  I think "swap on flash" is fair.  Though that
might be confused with making swap work on a NAND flash, which is very
much like the current block-io approach.  "Mmappable swap on flash" is
more exact, I suppose.

> > You need either a block translation layer,
>
> Are you suggesting to go through the block layer to reach the flash?

Well the obvious route would be to have this management layer use the
MTD, I can't see anything wrong with that.

> > or a (swap) filesystem that
> > understands flash peculiarities in order to make such a thing work.
> > The standard Linux swap format will not work.
>
> Correct.
>
> BTW, you may want to have a look at my "[RFC] VM: I have a dream..." thread.

Interesting.  This idea does allow for swap to be access directly.
