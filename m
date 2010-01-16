Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab0APDdL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758792Ab0APDc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:32:57 -0500
Received: from kroah.org ([198.145.64.141]:59170 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758235Ab0APDc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:32:56 -0500
Date: Fri, 15 Jan 2010 19:31:41 -0800
From: Greg KH <greg@kroah.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - reset inode permissions before
	unlinking
Message-ID: <20100116033141.GB15306@kroah.com>
References: <1263388596.26006.1.camel@yio.site> <20100114205304.GC3814@khazad-dum.debian.net> <ac3eb2511001141259t751c6063p8919692a8164e2b@mail.gmail.com> <20100114210743.GE3814@khazad-dum.debian.net> <ac3eb2511001141345w64d42ceckb4d73815298761c2@mail.gmail.com> <20100116022641.GF3814@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100116022641.GF3814@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 12:26:41AM -0200, Henrique de Moraes Holschuh wrote:
> On Thu, 14 Jan 2010, Kay Sievers wrote:
> > > That said, this does fix a possible security problem when a misconfigured
> > > system is used, and the fix looks rather simple... ?Can it go to -stable
> > > eventually, even if it is months in the future, after it gets some testing
> > > in .34 ? ? Minor problems are still problems...
> > 
> > Sure, we could do that. There is some stuff in the current .33 kernel,
> > which could go into .32-stable too, if that's useful.
> 
> I think it probably would be useful.  I understand .32 is going to stay with
> us for a long time, so it should get any fixes that have withstood the test
> of time.
> 
> It is very annoying to have subtly different kernel behaviour (from
> mainline) in a long-term stable series...

I've queued up this patch to go into the -stable trees.  Any other
specific one you can think of should also go?

thanks,

greg k-h
