Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbZDQPhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbZDQPhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZDQPhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:37:32 -0400
Received: from kroah.org ([198.145.64.141]:52725 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752666AbZDQPhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:37:31 -0400
Date: Fri, 17 Apr 2009 08:31:57 -0700
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core:fix driver_match_device
Message-ID: <20090417153157.GA15406@kroah.com>
References: <1238161800-4714-1-git-send-email-tom.leiming@gmail.com> <Pine.LNX.4.64.0904171239540.5119@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904171239540.5119@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 12:41:21PM +0200, Guennadi Liakhovetski wrote:
> On Fri, 27 Mar 2009, tom.leiming@gmail.com wrote:
> 
> > From: Ming Lei <tom.leiming@gmail.com>
> > 
> > This patch fixes a bug introduced in commit
> > 49b420a13ff95b449947181190b08367348e3e1b.
> > 
> > If a instance of bus_type doesn't have  .match method,
> > all .probe of drivers in the bus should be called, or else
> > the .probe have not a chance to be called.
> > 
> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> > Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> It looks like this patch is _still_ not in the mainline - now that we are 
> past rc2... Unless the problem has been fixed differently (I haven't 
> tested recent kernels), can we __please__ get it upstream?

It's in my queue to go to Linus today.

thanks,

greg k-h
