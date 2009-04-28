Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZD1FK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZD1FK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 01:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZD1FKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 01:10:47 -0400
Received: from kroah.org ([198.145.64.141]:33643 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbZD1FKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 01:10:46 -0400
Date: Mon, 27 Apr 2009 22:07:42 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.30-rc3] platform_bus:  remove "which
	platform_data?" confusion
Message-ID: <20090428050742.GB17432@kroah.com>
References: <200904271943.40588.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904271943.40588.david-b@pacbell.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 07:43:40PM -0700, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Recent patches have caused platform_device_add_pdata() users
> to trigger confused "use which platform_data?" error messages
> from the kernel.  ("The _only_ one you were given, dummy!" is
> the correct answer.)
> 
> This patch fixes those messages so they only appear if there's
> reason to be confused.  (The call should probably fail too...)
> 
> Those patches seem to support what I think is a misguided
> notion:  that somehow device.platform_data might move into
> the platform_device.  The problem with that idea is that it's
> a general purpose hook, and is used by other busses to provide
> board-specific configuration data ... not just for platform_bus.

It is?  What other busses do this?  And why, can't they use their own
bus private data pointers?

thanks,

greg k-h
