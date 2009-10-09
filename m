Return-Path: <linux-kernel-owner+w=401wt.eu-S933968AbZJIQ3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968AbZJIQ3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933935AbZJIQ3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:29:25 -0400
Received: from kroah.org ([198.145.64.141]:33644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933841AbZJIQ3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:29:24 -0400
Date: Fri, 9 Oct 2009 09:23:19 -0700
From: Greg KH <greg@kroah.com>
To: Steve Friedl <steve@unixwiz.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] staging: hv: Changed |typedef RING_BUFFER| to
 |struct hv_ring_buffer| throughout.
Message-ID: <20091009162319.GC2766@kroah.com>
References: <20090922054026.GA5959@dcent.unixwiz.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922054026.GA5959@dcent.unixwiz.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 10:40:26PM -0700, Steve Friedl wrote:
> The style guide (and Greg's prior work) have suggested that the typedef
> UPPERCASENAME style is not appropriate in the Linux kernel (even though
> it's been de rigueur in Win32 development for 20 years), so I'm fixing
> a couple more of them that remain... one at a time.
> 
> ~~~ Steve
> 
> Signed-off-by: Steve Friedl <steve@unixwiz.net>
> 
> ---
>  drivers/staging/hv/RingBuffer.c |    6 +++---

I'd rather not polish this turd anymore.  Can someone just replace the
ringbuffer.c code by using the in-kernel ringbuffer or kfifo code
instead?  I'd love to just delete this file completly, it does not
belong in the tree at all.

thanks,

greg k-h
