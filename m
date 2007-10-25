Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbXJYFrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbXJYFrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbXJYFrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:47:24 -0400
Received: from flatline.sindominio.net ([82.144.4.26]:50966 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbXJYFrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:47:23 -0400
Date: Thu, 25 Oct 2007 07:47:28 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] MBCS: Convert semaphores to the mutex API
Message-ID: <20071025054727.GN9824@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20071024170858.GH9824@traven> <20071024211149.2520a4ea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024211149.2520a4ea.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, Oct 24, 2007 at 09:11:49PM -0700 Andrew Morton ha dit:

> On Wed, 24 Oct 2007 19:08:58 +0200 matthias.kaehlcke@gmail.com wrote:
> 
> > MBCS: Convert the semaphores algolock, dmareadlock and dmawritelock to the 
> > mutex API
> 
> Thanks.  Has this actually been runtime-tested?

no, i could only test successfull compilation as i don't have the
device
 
> btw, your patches are in `patch -p2' form:
> 
> --- kernel.orig/linux-2.6/drivers/char/mbcs.c
> +++ kernel/linux-2.6/drivers/char/mbcs.c
> 
> should have been in `patch -p1' form:
> 
> --- linux-2.6/drivers/char/mbcs.c
> +++ linux-2.6/drivers/char/mbcs.c
> 
> I'd suggest that you grab and learn
> http://savannah.nongnu.org/projects/quilt/ - it takes care of all these
> things for you.

i actually used quilt for this patchset but must have missed
something. thanks for the pointer!

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

          Dreams and reality are opposites. Action synthesizes them
                             (Assata Shakur)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
