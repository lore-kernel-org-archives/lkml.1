Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbZEHSUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbZEHSUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbZEHST1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:19:27 -0400
Received: from smtp6.welho.com ([213.243.153.40]:49521 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762954AbZEHST0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:19:26 -0400
Date: Fri, 8 May 2009 21:19:24 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1-gpio: add external pull-up enable callback
Message-ID: <20090508181924.GR17782@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org
References: <1241527413-22920-1-git-send-email-daniel@caiaq.de> <20090506093307.GC17782@sci.fi> <20090506093445.GA31875@buzzloop.caiaq.de> <20090506202818.GH17782@sci.fi> <20090507013032.GA5456@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090507013032.GA5456@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 03:30:32AM +0200, Daniel Mack wrote:
> On Wed, May 06, 2009 at 11:28:18PM +0300, Ville Syrjälä wrote:
> > > > > This patch adds a callback function pointer to let users switch on and
> > > > > off the external pull-up resistor. This lets the outside world know
> > > > > whether the processor is currently actively driving the bus or not.
> > > > 
> > > > Looks simple enough but I wonder if you could just do this from the
> > > > platform code. I suppose the downside would be that you would enable the
> > > > pullup even if w1-gpio is not loaded.
> > > 
> > > That's right. Hence I put it where I believe it belongs to.
> > 
> > Well, if you think you need it who am I to argue :)
> > 
> > Acked-by: Ville Syrjälä <syrjala@sci.fi>
> 
> Thanks :)

BTW you should probably send this via Evgeniy Polyakov if you want it
included in the kernel at some point.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
