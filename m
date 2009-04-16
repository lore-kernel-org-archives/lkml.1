Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbZDPDG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbZDPDG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 23:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbZDPDGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 23:06:18 -0400
Received: from kroah.org ([198.145.64.141]:52763 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750966AbZDPDGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 23:06:17 -0400
Date: Wed, 15 Apr 2009 19:48:06 -0700
From: Greg KH <greg@kroah.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: device_for_each_child() before device_add() doesn't work
Message-ID: <20090416024806.GA4806@kroah.com>
References: <49E4BFD0.2020302@csr.com> <20090414165905.GA25645@kroah.com> <49E4D2FF.8090906@csr.com> <20090415051548.GC3462@kroah.com> <49E5F457.5090602@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E5F457.5090602@csr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 03:51:03PM +0100, David Vrabel wrote:
> Greg KH wrote:
> > 
> > So the problem is for the first device being added, right?  Can't you
> > just have a flag for this?
> 
> It's trivial to fix in the UWB stack.

I'd recommend doing that :)

> >> This address must be assigned during initialization and during normal 
> >> operation and in the past we didn't need to special case the address 
> >> assignment during initialization.
> > 
> > Does the patch below fix the problem for you?
> 
> Yes.

Thanks for testing, I've now added the patch to my tree.

greg k-h
