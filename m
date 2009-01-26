Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbZAZR5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbZAZR5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZAZR5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:57:04 -0500
Received: from kroah.org ([198.145.64.141]:39194 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751802AbZAZR5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:57:04 -0500
Date: Mon, 26 Jan 2009 09:51:15 -0800
From: Greg KH <greg@kroah.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Pavel Machek <pavel@suse.cz>,
       Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in
	wb35_probe()
Message-ID: <20090126175115.GA29205@kroah.com>
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 12:06:33PM +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> If successful, the usb_control_msg() function returns the number of
> bytes transferred. Fix up wb35_probe() to only bail out if the function
> returns a negative number.
> 
> Reported-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

I'm confused, should I apply this patch or not?

thanks,

greg k-h
