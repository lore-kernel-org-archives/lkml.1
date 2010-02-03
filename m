Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab0BCPti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:49:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:38409 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502Ab0BCPtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:49:33 -0500
Date: Wed, 3 Feb 2010 07:49:33 -0800
From: Greg KH <gregkh@suse.de>
To: CB <c.bartlett.crb@googlemail.com>
Cc: wfp5p@virginia.edu, npalix@diku.dk, hjanssen@microsoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: hv: fix various coding style issues in
	RingBuffer.c
Message-ID: <20100203154933.GA29964@suse.de>
References: <1265211267.24459.11.camel@pcgfx805-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265211267.24459.11.camel@pcgfx805-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 03:34:27PM +0000, CB wrote:
> >From a545464b8c98ca1f2b35b6b701842bca16a6cccf Mon Sep 17 00:00:00 2001
> From: C. Bartlett <c-bartlett@hotmail.co.uk>
> Date: Wed, 3 Feb 2010 15:08:17 +0000
> Subject: [PATCH] Staging: hv: fix various coding style issues in RingBuffer.c
>  This is a patch to the RingBuffer.c file that corrects various coding style  warnings and errors found by checkpatch.pl
>  Signed-off-by: Craig Bartlett <c-bartlett@hotmail.co.uk>

I'd really like to not take this patch, because this code should just be
replaced entirely with the in-kernel ringbuffer data structure instead
(as explained in the drivers/staging/hv/TODO file).

So could you work on that instead?  That way we can just delete this
file entirely, which would be best.

thanks,

greg k-h
