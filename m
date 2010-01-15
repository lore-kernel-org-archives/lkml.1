Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab0AOSFO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942Ab0AOSFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:05:00 -0500
Received: from kroah.org ([198.145.64.141]:36453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757935Ab0AOSE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:04:57 -0500
Date: Fri, 15 Jan 2010 10:03:41 -0800
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by
 default
Message-ID: <20100115180341.GA12146@kroah.com>
References: <1263505677.2074.2.camel@yio.site>
 <20100115065638.005ac690@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115065638.005ac690@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 06:56:38AM -0800, Arjan van de Ven wrote:
> On Thu, 14 Jan 2010 22:47:57 +0100
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Subject: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by
> > default
> > 
> > All major distros enable devtmpfs on recent systems, so remove
> > the EXPERIMENTAL flag, and enable it by default to reflect how it
> > is used today.
> 
> removing experimental is fine... but setting it by default is a bit
> over the top and very inconsistent with how the 'default' option is
> used.

Why?  All major distros need this at boot time, and as we have been
through a release cycle with the config option, anyone who is
incrementally updating will continue with their existing value.  But new
people coming in, will get the option as it is most likely required to
boot properly.

Makes sense to me.

thanks,

greg k-h
