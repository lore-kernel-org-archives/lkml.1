Return-Path: <linux-kernel-owner+w=401wt.eu-S1751858AbYJSRdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbYJSRdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 13:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYJSRdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 13:33:03 -0400
Received: from kroah.org ([198.145.64.141]:37853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751237AbYJSRdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 13:33:01 -0400
Date: Sun, 19 Oct 2008 10:29:01 -0700
From: Greg KH <greg@kroah.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20081019172901.GA22681@kroah.com>
References: <20081017220027.GA3659@kroah.com> <gdfauh$hsp$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gdfauh$hsp$1@ger.gmane.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 12:58:57PM +0000, Dmitry Baryshkov wrote:
> Greg KH wrote:
> 
> > Here is the big batch of USB patches for your 2.6-git tree.
> > 
> > These paches are:
> > 	- a few new USB drivers.
> > 	- new device ids
> > 	- lots of bugfixes
> > 	- additions to the USB api to make driver writer's lives easier. -
> > 	removals of usb macros that don't make sense to use anymore
> > 	  (warn() and info() should be using dev_warn() and dev_info()).
> > 	- other minor things.
> > 
> > All of these patches have been in the -next and -mm trees for quite a
> > while.
> 
> > 
> > Please pull from:
> > 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
> > 
> > The full patches will be sent to the linux-usb mailing list, if anyone
> > wants to see them.
> > 
> 
> What about TMIO OHCI driver? Will it be merged during this merge window?

That patch was dropped as it was causing a build error :)

Now with the fix, I can add it back, I just need to merge it into the
original.  It's in my queue and should go in soon.

thanks,

greg k-h
