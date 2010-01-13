Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565Ab0AMK5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0AMK5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465Ab0AMK5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:57:33 -0500
Received: from ozlabs.org ([203.10.76.45]:53046 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab0AMK5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:57:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 6/6] virtio: fix section mismatch warnings
Date: Wed, 13 Jan 2010 21:27:26 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20100113004855.550486769@suse.com> <20100113004939.463885987@suse.com>
In-Reply-To: <20100113004939.463885987@suse.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001132127.26873.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 11:19:01 am Jeff Mahoney wrote:
>  This patch fixes the following warnings by renaming the driver structures
>  to be suffixed with _driver.
> 
>  WARNING: drivers/virtio/virtio_balloon.o(.data+0x88): Section mismatch in reference from the variable virtio_balloon to the function .devexit.text:virtballoon_remove()
> 
>  WARNING: drivers/char/hw_random/virtio-rng.o(.data+0x88): Section mismatch in reference from the variable virtio_rng to the function .devexit.text:virtrng_remove()
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Andrew, will you take these?

Thanks,
Rusty.
