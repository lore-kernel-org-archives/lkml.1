Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYHRNbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYHRNbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 09:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYHRNa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 09:30:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4154 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751642AbYHRNa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 09:30:58 -0400
Date: Mon, 18 Aug 2008 15:30:38 +0200
From: Pavel Machek <pavel@suse.cz>
To: david@lang.hm
Cc: Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, peterz@infradead.org,
       hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080818133038.GA4819@ucw.cz>
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813103951.1e3e5827@infradead.org> <20080815160615.GD8860@ucw.cz> <alpine.DEB.1.10.0808180521010.12859@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808180521010.12859@asgard.lang.hm>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >How does it work? Memory can still change after mmap; 
> >scanning at the
> >mmap time is _NOT_ enough.
> >
> >You could do 'when app attempts to dirty memory, 
> >synchronously unmap
> >it from all apps that have it mapped' and then do sync 
> >scan on
> >pagefault time; but that sounds impractical.
> 
> what is the threat you are trying to defend against?
> 
> for some threats you are right, for others the scan at 
> mmap time is enough.

I don't see any threats when check at mmap time is okay.

As soon as file servers use mmap, this race can bite you even in very
simple 'make sure Linux fileserver does not pass on windows malwar'
threat model.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
