Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389Ab0ANBHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0ANBHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 20:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334Ab0ANBHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 20:07:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043Ab0ANBHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 20:07:51 -0500
Date: Wed, 13 Jan 2010 17:07:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] virtio: fix section mismatch warnings
Message-Id: <20100113170744.b45c9220.akpm@linux-foundation.org>
In-Reply-To: <201001132127.26873.rusty@rustcorp.com.au>
References: <20100113004855.550486769@suse.com>
	<20100113004939.463885987@suse.com>
	<201001132127.26873.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 21:27:26 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wed, 13 Jan 2010 11:19:01 am Jeff Mahoney wrote:
> >  This patch fixes the following warnings by renaming the driver structures
> >  to be suffixed with _driver.
> > 
> >  WARNING: drivers/virtio/virtio_balloon.o(.data+0x88): Section mismatch in reference from the variable virtio_balloon to the function .devexit.text:virtballoon_remove()
> > 
> >  WARNING: drivers/char/hw_random/virtio-rng.o(.data+0x88): Section mismatch in reference from the variable virtio_rng to the function .devexit.text:virtrng_remove()
> > 
> > Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Andrew, will you take these?
> 

umm, sure.  But I wish I knew how the patch worked.  Is there some
magic sauce which moves a variable called foo_driver into a different
section or what?

And if so, what was I doing when that got done :(
