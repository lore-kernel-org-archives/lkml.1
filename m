Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbYBLGWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbYBLGWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbYBLGV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:21:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:10526 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbYBLGV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:21:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MSi/3NsmKij4q1Hjl73oeHt6E8SJRr4CjJ0RhwZ8pYB4lMrptyhM7koc7pIuuUj/vDns9fEu8zL0w5ZrUTp6NSnloEzlh+KkJYS7UvjeRaEZUG3ERQWQhPLfJbQCuNZB+BjmrF69hAhSvCG3S+KpTl85IGGidb6wMDa2YirLG2w=
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20080211.221126.230471463.davem@davemloft.net>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	 <20080212044314.GA4888@kroah.com>
	 <20080211211751.3e265754@laptopd505.fenrus.org>
	 <20080211.221126.230471463.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 22:21:48 -0800
Message-Id: <1202797308.10004.41.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 22:11 -0800, David Miller wrote:
> From: Arjan van de Ven <arjan@infradead.org>
> Date: Mon, 11 Feb 2008 21:17:51 -0800
> 
> > this is why you need specific trees for just the API change
> 
> API trees don't work, just like other changes they will have
> interdependencies on things like fixups, cleanups, etc.
> 
> This is why, with the networking, we've just tossed all of the network
> driver stuff in there too.  I can rebase freely, remove changesets,
> rework them, etc. and this causes a very low amount of pain for Jeff
> Garzik and John Linville.
> 
> This may or not be a legitimate thing to do with other heavily
> dependant subsystems.

I was hoping that eventually certain pieces will stop moving and will
become a base that we can ask people to rebase on top of.  Perhaps
even asking that stuff destined for 2.6.x+1 go into a -next branch
and the more devel quality stuff go into a -mm branch that is based
off of their -next branch.  Gradually stuff would move from -mm
to -next, getting constantly integrated against other peoples' stuff.

More disruptive changes could go in and gradually as people rebase their
trees the conflicts would hopefully get less painful.

But, let's see how things go.

Harvey

