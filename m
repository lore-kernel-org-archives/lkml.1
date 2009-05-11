Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbZEKR4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbZEKR4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbZEKR4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:56:25 -0400
Received: from kroah.org ([198.145.64.141]:55879 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbZEKR4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:56:25 -0400
Date: Mon, 11 May 2009 10:43:01 -0700
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joerg.roedel@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reinette.chatre@intel.com
Subject: Re: dma-debug: add a check dma memory leaks
Message-ID: <20090511174301.GC4534@kroah.com>
References: <200903302101.n2UL1O1n011970@hera.kernel.org> <1240005065.19059.19.camel@macbook.infradead.org> <20090421092016.GH17438@amd.com> <1241913552.24436.113.camel@macbook.infradead.org> <20090510020911.GA4722@kroah.com> <1241945379.24436.130.camel@macbook.infradead.org> <1241947932.19955.10.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1241947932.19955.10.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 07:32:12PM +1000, Benjamin Herrenschmidt wrote:
> On Sun, 2009-05-10 at 09:49 +0100, David Woodhouse wrote:
> > > I don't understand.  Who wrote this patch, Joerg or you?  I have
> > this in
> > > my tree already as written by Joerg.
> > 
> > In that case we probably both did it, independently. I did it last
> > night
> > after finally catching up with Ben and talking about the possibility
> > of
> > moving the existing notifiers. Jörg may have done it sooner.
> > 
> > You can drop my version, then.
> 
> As long as it's strictly identical :-) IE. I don't want to -move- the
> existing notifier, but adding a "BOUND" one is fine.

Look in the linux-next tree to verify that it is the same.

Or here's a direct link to the patch:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-03-driver-core/driver-core-add-bus_notify_unbound_driver-event.patch

thanks,

greg k-h
