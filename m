Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbZGJRhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbZGJRhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZGJRhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 13:37:17 -0400
Received: from kroah.org ([198.145.64.141]:35541 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZGJRhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 13:37:15 -0400
Date: Fri, 10 Jul 2009 10:36:49 -0700
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com, dwmw2@infradead.org,
       kay.sievers@vrfy.org
Subject: Re: [PATCH] driver core:firmware_class:fix memory leak of page
 pointers array
Message-ID: <20090710173649.GB3687@kroah.com>
References: <1247098591-4887-1-git-send-email-tom.leiming@gmail.com>
 <d82e647a0907081720v438344fcj1b37e0e226818632@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0907081720v438344fcj1b37e0e226818632@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 08:20:48AM +0800, Ming Lei wrote:
> 2009/7/9  <tom.leiming@gmail.com>:
> > From: Ming Lei <tom.leiming@gmail.com>
> >
> > The page pointers array is allocated in fw_realloc_buffer() called by
> > firmware_data_write(), and should be freed in release function of firmware
> > device.
> >
> > Signed-off-by:Ming Lei <tom.leiming@gmail.com>
> > Reported-by:Catalin Marinas <catalin.marinas@arm.com>
> > Acked-by: David Woodhouse <David.Woodhouse@intel.com>
> 
> ---
> This patch is against Catalin Marinas's patch:
> 	[PATCH] Free struct device in fw_dev_release()

Hm, I never got a final version of that patch, care to send it to me?

thanks,

greg k-h
