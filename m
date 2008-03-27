Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYC0EL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYC0EL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 00:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbYC0ELs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 00:11:48 -0400
Received: from ns2.suse.de ([195.135.220.15]:36227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYC0ELr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 00:11:47 -0400
Date: Wed, 26 Mar 2008 21:13:06 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: mark gross <mgross@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Real time USB2Serial devices and behaivor
Message-ID: <20080327041306.GA10095@kroah.com>
References: <20080326232419.GC15468@kroah.com> <Pine.LNX.4.44L0.0803262255320.21714-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803262255320.21714-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 10:58:37PM -0400, Alan Stern wrote:
> On Wed, 26 Mar 2008, Greg KH wrote:
> 
> > > Is there any reason to think that if I created my own isochronous
> > > USB2Serial adapter and iso-usb-driver that I couldn't get determinism?
> > 
> > I strongly doubt it as others have tried and failed in the past.
> 
> I don't understand.  Isochronous transfers have pretty strict 
> transfer-time guarantees.  Why wouldn't this work?

I don't know, but the person who tried this a while ago said it wasn't
really "real-time" enough for their application (robot arm movement).

> One reason I can think of is that Iso transfers aren't reliable.  But
> then regular RS232-type serial transfers aren't reliable either.
> 
> The only other reason is that the USB stack itself has an unpredictable 
> amount of overhead.  However I think it should fall within an 
> acceptable range for RT applications.

It's all about bounding the longest latency.  Sometimes, under heavy
loads, latency can be pretty big.  But now that we have the -rt kernel,
it might be a lot better than before, so that might be possible now,
haven't tried it...

good luck,

greg k-h
