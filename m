Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZBRCX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZBRCX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 21:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZBRCXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 21:23:51 -0500
Received: from kroah.org ([198.145.64.141]:54348 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751777AbZBRCXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 21:23:51 -0500
Date: Tue, 17 Feb 2009 18:21:17 -0800
From: Greg KH <greg@kroah.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>,
       Karl Relton <karllinuxtest.relton@ntlworld.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       wlan-devel <linux-wlan-devel@lists.linux-wlan.com>
Subject: Re: [PATCH] staging/wlan-ng: block ioctls until card fully
	initialised
Message-ID: <20090218022117.GB32325@kroah.com>
References: <1234213202.6875.70.camel@dellpc> <20090209211700.GA10742@kroah.com> <1234478293.17792.1.camel@dellpc> <1234873158.2891.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234478293.17792.1.camel@dellpc> <1234873158.2891.29.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 12:19:18PM +0000, Richard Kennedy wrote:
> Add a mutex to block ioctls before the card is fully initialised and
> only allow one ioctl at a time.
> This stops udev trying to load the firmware before to card is fully up.
> 
> patch ported from wlan-ng-devel
> 
> Karl Relton <karllinuxtest.relton@ntlworld.com> spotted that this was
> missing from the staging version,
> http://lists.linux-wlan.com/pipermail/linux-wlan-devel/2009-February/003890.html 

Karl sent me a patch a few days before you that also added this
functionality.

Unfortunatly, both of your patches don't apply to the latest version of
the wlan-ng driver as it has had a lot of work done on it recently.

Could one of you grab the linux-next tree and make a patch up against
the version in it so that I can apply this?

thanks,

greg k-h
