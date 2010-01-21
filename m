Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303Ab0AUQie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab0AUQie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147Ab0AUQid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:38:33 -0500
Received: from kroah.org ([198.145.64.141]:59945 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab0AUQic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:38:32 -0500
Date: Thu, 21 Jan 2010 08:37:42 -0800
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by
 default
Message-ID: <20100121163742.GA13222@kroah.com>
References: <1263505677.2074.2.camel@yio.site>
 <20100115065638.005ac690@infradead.org>
 <20100115180341.GA12146@kroah.com>
 <20100117065803.6e5e089e@infradead.org>
 <ac3eb2511001200953g3fc2be3ay30174b0429707c93@mail.gmail.com>
 <20100120220553.66af4fd7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120220553.66af4fd7@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 10:05:53PM -0800, Arjan van de Ven wrote:
> On Wed, 20 Jan 2010 18:53:49 +0100
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > On Sun, Jan 17, 2010 at 15:58, Arjan van de Ven <arjan@infradead.org>
> > wrote:
> > > On Fri, 15 Jan 2010 10:03:41 -0800
> > > Greg KH <greg@kroah.com> wrote:
> > >> > removing experimental is fine... but setting it by default is a
> > >> > bit over the top and very inconsistent with how the 'default'
> > >> > option is used.
> > >>
> > >> Why?
> > >
> > > because the convention is that we use "default y" only for those
> > > things that used to be on, and are now turned into a config option.
> > 
> > Oh, I never heard of such a convention. Sure, we can remove that "y",
> > if this is the way it should be used, not be used.
> 
> For example in (this is just the first one google found, there's been a
> bunch of discussion at various times)
> 
> http://article.gmane.org/gmane.linux.kernel/706458
> 
> Linus was rather explicit:
> 
> The rule of thumb should be:
> 
> 	NO NEW FEATURES SHOULD _EVER_ DEFAULT TO 'ON'!

But this is not a "new" feature, it's been around for 6+ months by the
time it hits a release.  Does this imply that we can never change
anything to 'on' in the Kconfig files?

thanks,

greg k-h
