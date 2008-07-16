Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYGPOV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYGPOV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbYGPOVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:21:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:14661 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbYGPOVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:21:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gJQylY/v39v9aCoqC7TLgoHXdmdE0lBO9Ad8T3/NU+SScVpbK0bPQrFuoZWi4PYxx2
         078AAgNicYwEVR1IAet3nA+4zfQh6DbPYy2Nq9opDiX2ZC8nevDfA2sT4sO+8Ad7Kn4/
         Flt4tOVlRL28MJyiyE7k/mAzU/S1OcQvPHxMc=
Date: Wed, 16 Jul 2008 18:19:07 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Frans Pop <elendil@planet.nl>,
       david@lang.hm, Marcel Holtmann <marcel@holtmann.org>,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Prosaic firmware issues
Message-ID: <20080716141907.GA4540@martell.zuzino.mipt.ru>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org> <200807160222.40705.elendil@planet.nl> <alpine.LFD.1.10.0807151726520.2867@woody.linux-foundation.org> <487D441B.5010908@garzik.org> <20080716011140.GA30967@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0807151843240.2835@woody.linux-foundation.org> <1216187644.30898.7.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216187644.30898.7.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 10:54:04PM -0700, David Woodhouse wrote:
> On Tue, 2008-07-15 at 18:45 -0700, Linus Torvalds wrote:
> > 
> > On Wed, 16 Jul 2008, Alexey Dobriyan wrote:
> > >
> > > Could somebody from firmware people fix boring stuff, please:
> > > 
> > > 1) after allyesconfig build, git-status show plenty of crap:
> > 
> > Something like the appended, perhaps?
> > 
> > (I'm not going to commit it, I want some firmware person to double-check 
> > it).
> 
> Generally sane, but wants a few more things added.
> 
> > > 2) after "make mrproper" after allyesconfig, some files aren't removed,
> > >    use "git-ls-files -o" to see them.
> > 
> > Ok, that needs some Makefile magic. git magic I can do.
> 
> Ah, that's caused by a stray := where there should be a +=, so the
> firmware files listed before that get dropped from the list of files to
> be cleaned. 
> 
> Alexey, thanks for the report. Please could you verify that this fixes
> it for you?

It does, thank you.

