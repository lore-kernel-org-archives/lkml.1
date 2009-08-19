Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZHSSQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZHSSQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZHSSQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:16:41 -0400
Received: from kroah.org ([198.145.64.141]:48802 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZHSSQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:16:40 -0400
Date: Wed, 19 Aug 2009 11:14:26 -0700
From: Greg KH <greg@kroah.com>
To: Karl Relton <karllinuxtest.relton@ntlworld.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/wlan-ng: Convert firmware loading to load
 binary ihex format
Message-ID: <20090819181426.GA12827@kroah.com>
References: <1250665599.4545.3.camel@localhost>
 <20090819154437.GA729@kroah.com>
 <1250698851.4323.9.camel@localhost>
 <20090819163439.GA3094@kroah.com>
 <1250703549.4323.16.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250703549.4323.16.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 06:39:09PM +0100, Karl Relton wrote:
> On Wed, 2009-08-19 at 09:34 -0700, Greg KH wrote:
> > On Wed, Aug 19, 2009 at 05:20:51PM +0100, Karl Relton wrote:
> > > I plan to give the various distributions a utility to pre-compile the
> > > firmware. It is based on ihex2fw.c.
> > > 
> > > I don't think the firmware will ever be accepted into linux-firmware
> > > because the original licensing cannot be established.
> > 
> > Have you asked the company?
> > Where is the firmware at today?
> > 
> 
> At some point in the past the owner was Conexant, but we are not sure
> they still own in. Some efforts to track down which company now owns
> this firmware, and who the contact within that company would be, have
> been made but have not been successful.
> 
> The firmware is downloadable from the linux-wlan-ng project. I have been
> liasing with the maintainer in that project, who has tried to help as
> far as he could.

Ok, I'm just worried that if I take this change, then users whose
systems were working, will now break.  So, why would this change
actually help anyone out?

thanks,

greg k-h
