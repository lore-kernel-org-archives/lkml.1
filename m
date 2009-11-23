Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZKWONG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZKWONG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZKWONF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:13:05 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58984 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbZKWOND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:13:03 -0500
Date: Mon, 23 Nov 2009 14:12:55 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle
	changes
Message-ID: <20091123141255.GA9889@srcf.ucam.org>
References: <ac3eb2510911170755i5188fb53ud2d6012a2db8c00a@mail.gmail.com> <1258474180.16176.62.camel@localhost.localdomain> <20091117185742.GA19829@srcf.ucam.org> <ac3eb2510911181130l6f25642cy1d5332f79a112cf9@mail.gmail.com> <20091118194053.GB12944@srcf.ucam.org> <ac3eb2510911181147ufeacb58u5194b0e1e5fd86d6@mail.gmail.com> <20091118195342.GA13627@srcf.ucam.org> <ac3eb2510911181203r1be5c3dajdacec94f196d550c@mail.gmail.com> <20091118200712.GA14026@srcf.ucam.org> <20091122233749.GA9699@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091122233749.GA9699@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 12:37:49AM +0100, Pavel Machek wrote:
> On Wed 2009-11-18 20:07:12, Matthew Garrett wrote:
> > On Wed, Nov 18, 2009 at 09:03:21PM +0100, Kay Sievers wrote:
> > 
> > > Sure, but what's wrong with reading that file every 50 seconds? Almost
> > > all boxes poll for media changes of optical drives and usb card
> > > readers anyway, so it's not that we are not doing stuff like this
> > > already.
> > 
> > We poll for media because there's no event-based way of avoiding it - in 
> > this case there is.
> 
> ...when you add overhead to every disk operation. I'd say that polling
> once in 50 seconds is preferable to that.

Yeah, but 50 seconds isn't the timescale we're talking about here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
