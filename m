Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbXHGEMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbXHGEMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 00:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbXHGEM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 00:12:29 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51155 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXHGEM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 00:12:28 -0400
Date: Tue, 7 Aug 2007 06:13:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <gregkh@suse.de>
Cc: Nico Erfurth <masta@perlgolf.de>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH 2.6.22] Adding drivers/usb/misc/iowarrior.c to the Makefile
Message-ID: <20070807041345.GB1971@uranus.ravnborg.org>
References: <46B23DB0.5010702@perlgolf.de> <20070802212701.GA4326@uranus.ravnborg.org> <20070807030156.GB14310@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807030156.GB14310@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 08:01:56PM -0700, Greg KH wrote:
> On Thu, Aug 02, 2007 at 11:27:01PM +0200, Sam Ravnborg wrote:
> > On Thu, Aug 02, 2007 at 10:25:20PM +0200, Nico Erfurth wrote:
> > > This patch adds the new iowarrior module to the Makefile in drivers/usb.
> > > Currently the module isn't build unless another driver from usb/misc is
> > > selected.
> > 
> > Can we please just always vist misc like this:
> > obj-y := misc/
> > 
> > Then we do not need to repeat this stuff in both
> > drivers/usb/Makefile and drivers/usb/misc/Makefile
> 
> For some reason, we didn't do that because people were upset at us going
> into these directories when they didn't have any usb misc devices
> selected?  Or something like that, I really can't remember anymore.
> 
> But if you think it would be best to do that, I'd be glad to make the
> change.
Please do - we have too much duplication between the two files now.

	Sam
