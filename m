Return-Path: <linux-kernel-owner+w=401wt.eu-S967409AbXILMHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967409AbXILMHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967324AbXILMHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:07:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53174 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967316AbXILMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:07:31 -0400
Date: Wed, 12 Sep 2007 05:04:07 -0700
From: Greg KH <greg@kroah.com>
To: Andre Haupt <andre@finow14.de>, torvalds@osdl.org
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org
Subject: Re: hci_sock.c build failure
Message-ID: <20070912120407.GB13003@kroah.com>
References: <20070912092929.GA2878@ahaupt-debian-vm.localdomain> <20070912120253.GA13003@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912120253.GA13003@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 05:02:53AM -0700, Greg KH wrote:
> On Wed, Sep 12, 2007 at 11:29:29AM +0200, Andre Haupt wrote:
> > Hi,
> > 
> > I did a make randconfig and then make C=1.
> > 
> > hci_sock.c fails to build because it doesnt know compat_timeval (i
> > guess).
> > 
> > find the error message and the config attached.
> 
> It's not even a randconfig issue, my build dies too (this is Linus's
> current tree.)
> 
> Time to poke through the 10 bluetooth patches that were just added...

It was 767c5eb5d35aeb85987143f0a730bc21d3ecfb3d that caused it.  It
needs a .h file added to the file, patch forthcoming...

greg k-h
