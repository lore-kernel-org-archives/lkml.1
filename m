Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZCNUeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZCNUeg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 16:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZCNUe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 16:34:28 -0400
Received: from kroah.org ([198.145.64.141]:51041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753082AbZCNUe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 16:34:27 -0400
Date: Sat, 14 Mar 2009 13:32:56 -0700
From: Greg KH <greg@kroah.com>
To: Ralf Nyren <ralf@nyren.net>
Cc: linux-kernel@vger.kernel.org, klloyd@sierrawireless.com,
       rfiler@sierrawireless.com
Subject: Re: Sierra Wireless (MC8780) HSDPA speed issue
Message-ID: <20090314203256.GA7487@kroah.com>
References: <alpine.DEB.1.10.0903131551310.5791@fujje.iml.umu.se> <20090314040322.GB3417@kroah.com> <alpine.DEB.1.10.0903142021580.5797@fujje.iml.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903142021580.5797@fujje.iml.umu.se>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 08:34:40PM +0100, Ralf Nyren wrote:
> Hi,
> 
> I choose to only test download speeds for now but upload will also be of
> interest later on.
> 
> I had actually tried to change the N_IN_URB/N_OUT_URB before sending of the
> report but now I've been testing with both 8 and 128 but the speed remains the
> same. Download speed max 1.0Mbit/s in Linux while the Windows driver could get
> an average of 2.5Mbit/s at my current location (different location than during
> the last test).
> 
> I have also tried the new 1.6.0 driver as kindly supplied by Sierra but the
> speed remained the same 1.0Mbit/s with the new driver as well...
> 
> Anything else you think I could try?

Then this is not an issue on the kernel side, you might look higher up.
I have had reports of people incorrectly calculating network speeds
compared to Windows due to other tools running at the time, or
misconfigured networks.

As for how to look into this, sorry, I really don't know.

good luck,

greg k-h
