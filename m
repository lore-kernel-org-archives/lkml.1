Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYKZRg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYKZRg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYKZRgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:36:07 -0500
Received: from kroah.org ([198.145.64.141]:41574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754063AbYKZRgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:36:05 -0500
Date: Wed, 26 Nov 2008 09:34:59 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@suse.cz>
Cc: penberg@cs.helsinki.fi, kernel list <linux-kernel@vger.kernel.org>,
       rdunlap@xenotime.net
Subject: Re: w35und: fix Kconfig
Message-ID: <20081126173459.GA17545@kroah.com>
References: <20081124091829.GA30292@elf.ucw.cz> <20081126161516.GB1983@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126161516.GB1983@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 05:15:16PM +0100, Pavel Machek wrote:
> 
> 4KSTACK dependency was needed when driver carried its own softmac
> layer. That layer is gone, and functions have reasonably small stack
> footprint -> dependency can be removed.
> 
> Add better description of hardware this driver is targetted at (now
> with fixed whitespace)

My scripts automatically strip off trailing whitespace (well, quilt
does), so this wasn't that necessary.  But I've now replaced the version
of this patch in my tree with your new one.

thanks,

greg k-h
