Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZEJSbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZEJSbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 14:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZEJSbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 14:31:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53750 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbZEJSbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 14:31:12 -0400
Subject: Re: [patch 00/13] devtmpfs patches
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090510152005.GA9461@suse.de>
References: <20090509143742.GA27663@kroah.com>
	 <b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
	 <20090509150853.GA32394@suse.de> <20090509082233.32cbb8e4@infradead.org>
	 <20090509161923.GA942@suse.de>
	 <20090509223454.4642753d.akpm@linux-foundation.org>
	 <20090510152005.GA9461@suse.de>
Content-Type: text/plain
Date: Sun, 10 May 2009 20:31:03 +0200
Message-Id: <1241980263.9562.380.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-10 at 08:20 -0700, Greg KH wrote:
> On Sat, May 09, 2009 at 10:34:54PM -0700, Andrew Morton wrote:
> > On Sat, 9 May 2009 09:19:23 -0700 Greg KH <gregkh@suse.de> wrote:
> > 
> > >  We need to be able to support large number of partitions at boot
> > > time. 
> > 
> > I suspect that the intersection between (systems which need to shave
> > boot time to the minimum) and (systems which have lots of partitions)
> > is quite small?
> 
> No, not at all, lots of desktops have one or two disks with 15+
> partitions.  Those users want fast boot times as well.

/me boggles, however does one end up with that many partitions on so few
disks? 

/boot
/
/home
/usr
swap
/usr/local
/opt

and I'm seriously out of sensible ideas.

