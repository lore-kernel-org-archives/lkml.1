Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZG2NVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZG2NVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbZG2NVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:21:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:41727 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbZG2NVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:21:35 -0400
Date: Wed, 29 Jul 2009 06:13:24 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Palix <npalix@diku.dk>, hjanssen@microsoft.com,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Staging: hv: Fix warning by casting a (const void
 *) to (void *)
Message-ID: <20090729131324.GA28049@suse.de>
References: <200907291410.29355.npalix@diku.dk>
 <200907291508.24608.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907291508.24608.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 03:08:24PM +0200, Arnd Bergmann wrote:
> On Wednesday 29 July 2009, Nicolas Palix wrote:
> > Fix compilation warning by casting the const void *Buffer
> > variable into a void *.
> > 
> > Signed-off-by: Nicolas Palix <npalix@diku.dk>
> 
> Not sure if this one is worthwhile. Replacing SG_BUFFER_LIST
> with the existing struct scatterlist might be a better
> fix, as sg_set_buf() does not generate a warning like this
> anyway.

Yes, that's the correct fix to make.  That should be done instead.

thanks,

greg k-h
