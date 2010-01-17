Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676Ab0AQH4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab0AQH4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 02:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124Ab0AQH4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 02:56:42 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51447 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0AQH4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 02:56:41 -0500
Date: Sun, 17 Jan 2010 08:56:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by
	default
Message-ID: <20100117075633.GA1339@ucw.cz>
References: <1263505677.2074.2.camel@yio.site> <20100115065638.005ac690@infradead.org> <20100115180341.GA12146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115180341.GA12146@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-01-15 10:03:41, Greg KH wrote:
> On Fri, Jan 15, 2010 at 06:56:38AM -0800, Arjan van de Ven wrote:
> > On Thu, 14 Jan 2010 22:47:57 +0100
> > Kay Sievers <kay.sievers@vrfy.org> wrote:
> > 
> > > From: Kay Sievers <kay.sievers@vrfy.org>
> > > Subject: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by
> > > default
> > > 
> > > All major distros enable devtmpfs on recent systems, so remove
> > > the EXPERIMENTAL flag, and enable it by default to reflect how it
> > > is used today.
> > 
> > removing experimental is fine... but setting it by default is a bit
> > over the top and very inconsistent with how the 'default' option is
> > used.
> 
> Why?  All major distros need this at boot time, and as we have been
> through a release cycle with the config option, anyone who is
> incrementally updating will continue with their existing value.  But new
> people coming in, will get the option as it is most likely required to
> boot properly.

Defaults should be back-compatible. This is not... people should be
still able to skip releases when upgrading.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
