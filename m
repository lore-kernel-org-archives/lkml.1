Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbZEDO5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbZEDO5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZEDO5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:57:08 -0400
Received: from kroah.org ([198.145.64.141]:44193 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbZEDO5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:57:07 -0400
Date: Mon, 4 May 2009 07:53:48 -0700
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Brownell <david-b@pacbell.net>, Oliver Neukum <oliver@neukum.org>,
       Li Hong <lihong.hi@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: use memdup_user()
Message-ID: <20090504145348.GA10545@kroah.com>
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com> <3a3680030905032038h40cd75bdrbee839117e5a4d55@mail.gmail.com> <200905040854.03329.oliver@neukum.org> <200905040002.38304.david-b@pacbell.net> <84144f020905040041n721336a0t4c0f4c25eb272abf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020905040041n721336a0t4c0f4c25eb272abf@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 10:41:51AM +0300, Pekka Enberg wrote:
> Hi!
> 
> On Sunday 03 May 2009, Oliver Neukum wrote:
> >> No. To make it plain. To me any use of memdup_user() in USB code
> >> is a bad idea. I don't want to have to think about a new primitive.
> 
> On Mon, May 4, 2009 at 10:02 AM, David Brownell <david-b@pacbell.net> wrote:
> > Unless it's incorrect to use that, I have to say that it
> > makes more sense to use that utility than recreate it by
> > open-coding...
> 
> Yup, and I don't really see how anyone can avoid "thinking about a new
> primitive" anyway. We have it in the kernel now and surely it will
> appear under drivers/usb/ sooner or later...

Well, how about passing the GPF flags down to memdup_user() so that we
can use it in the usb subsystem, and Oliver's complaint will be resolve?

thanks,

greg k-h
