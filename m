Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZBRPfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZBRPfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZBRPfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:35:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbZBRPfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:35:22 -0500
Date: Wed, 18 Feb 2009 07:29:13 -0800
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export device_add_attributes() so drivers can use it.
Message-ID: <20090218152913.GA26448@suse.de>
References: <20090218151132.476.81706.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218151132.476.81706.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 08:11:34AM -0700, Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> I find myself using the pattern of device_add_attributes() and
> device_remove_attributes() frequently in my drivers.  Rather than
> reinventing the wheel every time, I'm floating this patch to export
> the symbols to see how it is received.  If this looks okay then I'll
> rework my drivers and post additional patches to use these functions.

No objection from me, as long as the symbols are EXPORT_SYMBOL_GPL(),
like the rest of the driver core.  Is that ok with you?

thanks,

greg k-h
