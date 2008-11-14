Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYKNTUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYKNTUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYKNTUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:20:32 -0500
Received: from kroah.org ([198.145.64.141]:33770 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753165AbYKNTUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:20:31 -0500
Date: Fri, 14 Nov 2008 11:15:45 -0800
From: Greg KH <greg@kroah.com>
To: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
Cc: Greg KH <gregkh@suse.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20081114191545.GA24115@kroah.com>
References: <20081113230259.GA3681@kroah.com> <19F8576C6E063C45BE387C64729E739403E5F2B47B@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E739403E5F2B47B@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 09:36:03AM +0530, Gupta, Ajay Kumar wrote:
> Hi Greg,
> 
> There is a difference in the musb patch I submitted and the one which actually has been
> forwarded to you by Felipe. This difference has introduced a bug.
> 
> The patch in you series is,
> usb: musb: fix BULK request on different available endpoints
> 
> 
> It was submitted by me at,
> http://marc.info/?l=linux-usb&m=122337227617797&w=2
> 
> 
> And the one which is forwarded to you by Felipe is at,
> http://marc.info/?l=linux-usb&m=122528597316728&w=2
> 
> 
> There is a difference in between above two as below.
> Original: +	if (best_end < 0 && qh->type == USB_ENDPOINT_XFER_BULK) {
> Sent to you: +	if (best_end > 0 && qh->type == USB_ENDPOINT_XFER_BULK) {
> 
> It should be [best_end < 0].
> 
> If it is possible then please correct this mismatch in your series.

I'll wait to get a patch from Felipe for this.

thanks,

greg k-h
