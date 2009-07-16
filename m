Return-Path: <linux-kernel-owner+w=401wt.eu-S933513AbZGPWrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbZGPWrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933497AbZGPWrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:47:39 -0400
Received: from kroah.org ([198.145.64.141]:40543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933070AbZGPWri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:47:38 -0400
Date: Thu, 16 Jul 2009 15:41:40 -0700
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com, dwmw2@infradead.org,
       kay.sievers@vrfy.org
Subject: Re: [PATCH] driver core:firmware_class:fix memory leak of page
 pointers array
Message-ID: <20090716224140.GA12401@kroah.com>
References: <1247098591-4887-1-git-send-email-tom.leiming@gmail.com>
 <d82e647a0907081720v438344fcj1b37e0e226818632@mail.gmail.com>
 <20090710173649.GB3687@kroah.com>
 <20090711111110.6be67d82@linux-lm>
 <d82e647a0907160622y2ec1798eue1310b7feaf79114@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d82e647a0907160622y2ec1798eue1310b7feaf79114@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 09:22:33PM +0800, Ming Lei wrote:
> 2009/7/11 Ming Lei <tom.leiming@gmail.com>:
> > On Fri, 10 Jul 2009 10:36:49 -0700
> > Greg KH <greg@kroah.com> wrote:
> >
> >> On Thu, Jul 09, 2009 at 08:20:48AM +0800, Ming Lei wrote:
> >> > 2009/7/9  <tom.leiming@gmail.com>:
> >> > > From: Ming Lei <tom.leiming@gmail.com>
> >> > >
> >> > > The page pointers array is allocated in fw_realloc_buffer()
> >> > > called by firmware_data_write(), and should be freed in release
> >> > > function of firmware device.
> >> > >
> >> > > Signed-off-by:Ming Lei <tom.leiming@gmail.com>
> >> > > Reported-by:Catalin Marinas <catalin.marinas@arm.com>
> >> > > Acked-by: David Woodhouse <David.Woodhouse@intel.com>
> >> >
> >> > ---
> >> > This patch is against Catalin Marinas's patch:
> >> >     [PATCH] Free struct device in fw_dev_release()
> >>
> >> Hm, I never got a final version of that patch, care to send it to me?
> 
> Hi,Greg
> 
> Care to queue the patch into your driver-core tree and send it to -rc4?

Now queued up.

thanks,

greg k-h
