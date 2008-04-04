Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbYDDCis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbYDDCis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 22:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYDDCii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 22:38:38 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:10226
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756028AbYDDCih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 22:38:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgAAGYx9Ud8qMuH/2dsb2JhbAAIrBM
X-IronPort-AV: E=Sophos;i="4.25,601,1199631600"; 
   d="scan'208";a="201036796"
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
From: Ben Nizette <bn@niasdigital.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804031844500.11928@t2.domain.actdsltmp>
References: <200710291809.29936.david-b@pacbell.net>
	 <200711301040.54777.david-b@pacbell.net>
	 <20071130211332.49a21a6b@hyperion.delvare>
	 <200711301259.22666.david-b@pacbell.net>
	 <Pine.LNX.4.64.0804031844500.11928@t2.domain.actdsltmp>
Content-Type: text/plain
Organization: Nias Digital
Date: Fri, 04 Apr 2008 13:45:35 +1100
Message-Id: <1207277135.4082.37.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-03 at 19:06 -0700, Trent Piepho wrote:
> On Fri, 30 Nov 2007, David Brownell wrote:
> > On Friday 30 November 2007, Jean Delvare wrote:
> >>
> >> So the user-space interface would be part of the generic GPIO
> >> infrastructure? I like the idea.
> >
> > I thought that would make sense too! :)  Someone would need to
> > write the code though.  Having such a mechanism would provide
> > another "carrot" to migrate folk towards the gpiolib core.
> 
> Here's some code to do this.  It's not entirely perfect yet, but it is
> usable.

I quite like the fact that this easily tracks labels but I like the
interface of simple_gpio posted a few days back:
http://lkml.org/lkml/2008/3/26/87

Either way, anything unified is good.

	--Ben.
