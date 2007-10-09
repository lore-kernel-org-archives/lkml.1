Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbXJIUuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbXJIUuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 16:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbXJIUuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 16:50:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46186 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbXJIUuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 16:50:13 -0400
Date: Tue, 9 Oct 2007 13:46:42 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: david-b@pacbell.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: OHCI root_port_reset() deadly loop...
Message-ID: <20071009204642.GA11575@kroah.com>
References: <20071009043643.773CC23715F@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20071008.214408.98397070.davem@davemloft.net> <20071009163827.E7DB310B535@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20071009.134116.63997473.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009.134116.63997473.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 01:41:16PM -0700, David Miller wrote:
> From: David Brownell <david-b@pacbell.net>
> Date: Tue, 09 Oct 2007 09:38:27 -0700
> 
> > > > What values do you see for "portstat"?
> > >
> > > 0x111
> > 
> > That's unfortunately useless ... PPS, PRS, CCS (meaning powered,
> > resetting, connected).  In short, there is *no* indication from
> > the OHCI hardware that a disconnect happened.
> 
> But it's an excellent example of why my patch is mandatory.

I agree.  David Brownell, unless you strongly object, I'll take David
Miller's patch and add it to my tree.

And if you do object, can you respond to the objection with a version of
the patch that you would accept?  :)

thanks,

greg k-h
