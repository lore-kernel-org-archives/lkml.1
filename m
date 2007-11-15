Return-Path: <linux-kernel-owner+w=401wt.eu-S1765634AbXKOSke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765634AbXKOSke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbXKOSk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:40:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37382 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbXKOSkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:40:25 -0500
Date: Thu, 15 Nov 2007 10:34:37 -0800
From: Greg KH <greg@kroah.com>
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       shemminger@linux-foundation.org, Justin Forbes <jmforbes@linuxtx.org>,
       linux-kernel@vger.kernel.org, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/16] 2.6.23-stable review, network driver
	changes
Message-ID: <20071115183437.GB14500@kroah.com>
References: <20071115063921.GA18827@kroah.com> <20071115122448.GK8865@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115122448.GK8865@zakalwe.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 02:24:48PM +0200, Heikki Orsila wrote:
> On Wed, Nov 14, 2007 at 10:39:21PM -0800, Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.23.X release.
> > There are 16 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.
> > ...
> >  drivers/net/skge.c                     |  141 +++++++++++++++++----------------
> >  drivers/net/skge.h                     |    6 -
> 
> I found a regression when I applied drivers/net/skge.[ch] patches on top 
> of 2.6.23.1 at stable tree (4367388f04eea72e78347dc9b299698bf4275f92). 
> It hangs the network on high speed transfers.
> 
> This the same regression that happened for 2.6.24-rc*:
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=9321
> 
> The driver in 2.6.23.1 works for me. Afaik, Stephen Hemminger is working 
> on it.

Thanks, I've removed the offending patch, as has Linus from his tree.

greg k-h
