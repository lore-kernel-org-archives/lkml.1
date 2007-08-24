Return-Path: <linux-kernel-owner+w=401wt.eu-S1764593AbXHXOX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764593AbXHXOX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758523AbXHXOXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 10:23:22 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:58418 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbXHXOXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 10:23:21 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [RFC] USB: driver for iphone charging
Date: Fri, 24 Aug 2007 16:23:13 +0200
User-Agent: KMail/1.9.7
Cc: Greg KH <greg@kroah.com>, Matt Colyer <matt@colyer.name>,
       linux-kernel@vger.kernel.org, jeffm@suse.de,
       linux-usb-devel@lists.sourceforge.net
References: <Pine.LNX.4.44L0.0708241006440.3862-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708241006440.3862-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241623.13887.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 24 August 2007 schrieb Alan Stern:
> On Fri, 24 Aug 2007, Oliver Neukum wrote:
> 
> > This schedules the change via a workqueue, so you'll be reprobed. If you
> > fire of the first vendor command you are doing so before the configuration
> > is changed. How is this supposed to work?
> 
> I would do it like this:

That makes sense. However, Greg's version might work by putting
out a magic init sequence and then changing the configuration.
Then it would just be coded in an obscure way.

However, does this really belong into kernel space? We have been
knowing that user space infrastructure for configuration selection
is necessary and this seems like a fine starting point.

	Regards
		Oliver
