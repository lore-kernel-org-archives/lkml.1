Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbXBJODh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbXBJODh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 09:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113AbXBJODg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 09:03:36 -0500
Received: from ns.suse.de ([195.135.220.2]:58224 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101AbXBJODg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 09:03:36 -0500
From: Andi Kleen <ak@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: remote debugging via FireWire (was What will be in the x86-64/x86 2.6.21 merge)
Date: Sat, 10 Feb 2007 15:02:59 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org,
       linux1394-devel@lists.sourceforge.net, Bernhard Kaindl <bk@suse.de>
References: <200702101242.48467.ak@suse.de> <45CDCDCD.5000609@s5r6.in-berlin.de>
In-Reply-To: <45CDCDCD.5000609@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702101502.59431.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 14:51, Stefan Richter wrote:
> Andi Kleen wrote at LKML:
> ...
> > Not likely to make .21:
> ...
> > - Early firewire support for firescope at early boot
> ...
> 
> Was it seen in canonical patch format on a mailinglist before?

Don't know.

> Is it Bernhard Kaindl's ohci1394_early?
> http://www.suse.de/~bk/firewire/

Yes.
> 
> Would be good to put this on the usual patch-submission road in order to
> prep it for 2.6.22. Could be handled via linux1394-2.6.git, although a
> different channel where the actual users of this facility watch would
> IMO be more appropriate.

It's more related to arch code than firewire, so I thought i would
handle it. But you can too if you want. It definitely needs much
more review anyways.

> A mostly unrelated note: A simple to set up remote-dmesg utility would
> be nice to have on the terminal side.

ftp://ftp.firstfloor.org/pub/ak/firescope/

-Andi
