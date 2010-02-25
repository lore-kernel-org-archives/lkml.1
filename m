Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab0BYQV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:21:26 -0500
Received: from kroah.org ([198.145.64.141]:60012 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866Ab0BYQVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:21:23 -0500
Date: Thu, 25 Feb 2010 08:14:13 -0800
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oliver Neukum <oliver@neukum.org>, Yuhong Bao <yuhongbao_386@hotmail.com>,
       hancockrwd@gmail.com, david-b@pacbell.net, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA
 support
Message-ID: <20100225161413.GA1229@kroah.com>
References: <4B7CAF95.6020306@gmail.com>
 <SNT125-W36AFF0BF953EABAC9A0432C3400@phx.gbl>
 <4B85EE88.5050506@kernel.org>
 <201002250503.09327.oliver@neukum.org>
 <4B8609CE.5000705@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8609CE.5000705@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 02:25:34PM +0900, Tejun Heo wrote:
> On 02/25/2010 01:03 PM, Oliver Neukum wrote:
> > Am Donnerstag, 25. Februar 2010 04:29:12 schrieb Tejun Heo:
> >> Arghhh.... I hate when intel pulls this type of 'product
> >> differentiation' stunts.  At any rate, I'm doubtful swiotlb'ing for
> >> usb2.0 would be noticeable at all.
> > 
> > That can and should be tested.
> 
> Robert did already.  Given that USB2.0 devices aren't usually used for
> high-perf storage subsystem, the benefit looks marginal to me but
> everyone is entitled to own opinion.

For now, I'd like to not enable this, given the huge risks and no known
benifit.

For USB 3.0, we can reconsider it, as it might start to make a
difference there.

thanks,

greg k-h
