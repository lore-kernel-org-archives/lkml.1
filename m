Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbXFNTM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbXFNTM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXFNTMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:12:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49499 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbXFNTMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:12:52 -0400
Date: Thu, 14 Jun 2007 12:12:06 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Huang, Ying" <ying.huang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: multithreaded device matching with
	dependency
Message-ID: <20070614191206.GA13589@kroah.com>
References: <9D7649D18729DE4BB2BD7B494F7FEDC2041319@pdsmsx415.ccr.corp.intel.com> <466AD638.9030409@s5r6.in-berlin.de> <1181643157.2779.23.camel@caritas-dev.intel.com> <466EAE21.7090407@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466EAE21.7090407@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 04:30:57PM +0200, Stefan Richter wrote:
> 
> There is so much unskilled labor in driver hacking land (I'm merely
> speaking for myself of course) that something like the driver core
> /really/ needs well-working, easy to understand, and well-documented APIs.
> 
> PS:  By a well-documented struct definition I mean:
>    - Public members have a type and name which indicate the meaning of
>      the member, and there is a comment on permissible or required
>      write/read accesses to the member.
>    - Private members are undocumented or even better yet explicitly
>      marked as private.

We are slowly working toward this goal with the cleanups and work that
Kay has been doing over the past year.  So be patient, it is slowly
coming, or please help out if you can.

> If the access methods to public members turn out too difficult and
> fragile, make the members private and provide documented public accessors.

Well, let's not get into the whole "accessors are good/evil" type thread
here, but yes, we'll work to try to make this whole thing easier to use
and very hard to use incorrectly (which is not true today, I know,
sorry...)

thanks,

greg k-h
