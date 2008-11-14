Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYKNUDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYKNUDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 15:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYKNUDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 15:03:06 -0500
Received: from kroah.org ([198.145.64.141]:47610 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751898AbYKNUDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 15:03:05 -0500
Date: Fri, 14 Nov 2008 11:59:48 -0800
From: Greg KH <greg@kroah.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>, Greg KH <gregkh@suse.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20081114195948.GA25682@kroah.com>
References: <20081113230259.GA3681@kroah.com> <19F8576C6E063C45BE387C64729E739403E5F2B47B@dbde02.ent.ti.com> <20081114191545.GA24115@kroah.com> <491DD440.9000402@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491DD440.9000402@ru.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 10:40:48PM +0300, Sergei Shtylyov wrote:
> Hello.
>
> Greg KH wrote:
>
>>> Hi Greg,
>
>>> There is a difference in the musb patch I submitted and the one which 
>>> actually has been
>>> forwarded to you by Felipe. This difference has introduced a bug.
>
>>> The patch in you series is,
>>> usb: musb: fix BULK request on different available endpoints
>
>>> It was submitted by me at,
>>> http://marc.info/?l=linux-usb&m=122337227617797&w=2
>
>>> And the one which is forwarded to you by Felipe is at,
>>> http://marc.info/?l=linux-usb&m=122528597316728&w=2
>
>>> There is a difference in between above two as below.
>>> Original: +	if (best_end < 0 && qh->type == USB_ENDPOINT_XFER_BULK) {
>>> Sent to you: +	if (best_end > 0 && qh->type == USB_ENDPOINT_XFER_BULK) {
>
>>> It should be [best_end < 0].
>
>>> If it is possible then please correct this mismatch in your series.
>
>> I'll wait to get a patch from Felipe for this.
>
>    I'm seeing it being to you sent at least a week ago -- look for "usb: 
> musb: fix bug in musb_schedule".

As Felipe is the maintainer of the musb code, and has been batching up
patches and sending them on to me when needed, I have only been taking
them from him.

So that message is long deleted from my mail, sorry.

thanks,

greg k-h
