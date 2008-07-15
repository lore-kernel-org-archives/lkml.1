Return-Path: <linux-kernel-owner+w=401wt.eu-S1763499AbYGOUoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763499AbYGOUoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763378AbYGOUnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:43:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52986 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759180AbYGOUnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:43:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Tue, 15 Jul 2008 22:45:44 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <1216079223.27455.92.camel@shinybook.infradead.org>
In-Reply-To: <1216079223.27455.92.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807152245.44817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 15 of July 2008, David Woodhouse wrote:
> On Mon, 2008-07-14 at 16:41 -0700, Andrew Morton wrote:
> > On Mon, 14 Jul 2008 16:23:26 -0700
> > David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > Linus, please pull from the for-2.6.27 branch of:
> > > 	git://git.infradead.org/users/dwmw2/firmware-2.6.git for-2.6.27
> > 
> > The firmware flamewars seem to have subsided lately.  Is everyone happy
> > with this now?
> 
> I've deliberately left drivers/net out of this pull request... all
> _other_ maintainers seemed quite happy to see their drivers updated to
> use request_firmware().

Have you fixed the issue with FORCE in line 117 of scripts/Makefile.host?

Rafael
