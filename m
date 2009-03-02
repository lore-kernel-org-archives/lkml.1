Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbZCBWpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbZCBWpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZCBWpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:45:20 -0500
Received: from kroah.org ([198.145.64.141]:48050 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754734AbZCBWpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:45:19 -0500
Date: Mon, 2 Mar 2009 14:39:16 -0800
From: Greg KH <greg@kroah.com>
To: Mike Murphy <mamurph@cs.clemson.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       oliver@neukum.org, fweisbec@gmail.com, torvalds@linux-foundation.org
Subject: Re: PATCH [1/3] drivers/input/xpad.c: Improve Xbox 360 wireless
	support and add sysfs interface
Message-ID: <20090302223916.GA31381@kroah.com>
References: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com> <20090302130425.23cc628d.akpm@linux-foundation.org> <20090302211820.GA21489@kroah.com> <20090302133551.1266f725.akpm@linux-foundation.org> <5aa163d00903021359x3a4693f5tbb7f1e3fec4d88b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aa163d00903021359x3a4693f5tbb7f1e3fec4d88b8@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 04:59:48PM -0500, Mike Murphy wrote:
> As I was coding this interface, I found myself wishing for a
> macro-based system like module parameters have. For example, it would
> be nice to be able to do something like the following:
> 
> DECLARE_SYSFS_INTERFACE(&xpad->dead_zone, uint, &check_dead_zone);
> 
> which would create the needed show/store functions that worked with an
> unsigned int. The check_dead_zone function would be a validator
> function inside the module that would check the validity on a
> user-supplied value on store (in this case, to be sure it was at least
> 1024 below the stick limit) and return an error code if the value were
> out of range. Yes, the validator would be an extra function call, but
> this code doesn't run in an interrupt context, so the benefit of being
> able to centralize the functionality and simplify drivers might be
> worth the extra overhead.

I tried to create such an interface years ago, and the macro tricks
involved ended up being horrible, and in the end, it didn't work.  But
if you can come up with something, I'd love to see it.

thanks,

greg k-h
