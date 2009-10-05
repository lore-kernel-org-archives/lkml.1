Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZJEQHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZJEQHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 12:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZJEQHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 12:07:03 -0400
Received: from kroah.org ([198.145.64.141]:33369 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbZJEQHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 12:07:02 -0400
Date: Mon, 5 Oct 2009 09:03:50 -0700
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers-core: nullify private pointer on device-release
Message-ID: <20091005160350.GA13522@kroah.com>
References: <Pine.LNX.4.64.0910010950330.4408@axis700.grange>
 <20091001132709.GA2221@kroah.com>
 <Pine.LNX.4.64.0910011533220.4408@axis700.grange>
 <20091001141524.GA3355@kroah.com>
 <Pine.LNX.4.64.0910051011280.4337@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910051011280.4337@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 10:11:50AM +0200, Guennadi Liakhovetski wrote:
> On Thu, 1 Oct 2009, Greg KH wrote:
> 
> > On Thu, Oct 01, 2009 at 03:45:56PM +0200, Guennadi Liakhovetski wrote:
> > > On Thu, 1 Oct 2009, Greg KH wrote:
> > > 
> > > > On Thu, Oct 01, 2009 at 10:02:08AM +0200, Guennadi Liakhovetski wrote:
> > > > > Device structures can be reused over multiple device_add / device_release 
> > > > > cycles.
> > > > 
> > > > They shouldn't be as they should be dynamic, not static.
> > > 
> > > Should they? I'm pretty sure this is not the first time this comes up - 
> > > there are several drivers and / or subsystems, that re-use driver objects. 
> > 
> > Then those drivers and subsystems should be fixed, as that is incorrect.
> > 
> > > But finding in mail archives wouldn't be very easy. And it worked until 
> > > now - why should we break it?
> > 
> > I would argue that this code was always broken.
> > When did this problem show up for you?
> 
> Since commit b4028437876866aba4747a655ede00f892089e14

Again, which driver/devices are having this problem?  The patch
referenced above had been in linux-next for almost 6 months with no
reported problems, so this is news to me :)

thanks,

greg k-h
