Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZEKVmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZEKVmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbZEKVlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:41:52 -0400
Received: from kroah.org ([198.145.64.141]:60444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757952AbZEKVlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:41:51 -0400
Date: Mon, 11 May 2009 14:06:22 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Paul Mackerras <paulus@samba.org>,
       Roel Kluin <roel.kluin@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hvcs: remove driver_data direct access of struct device
Message-ID: <20090511210622.GD31999@kroah.com>
References: <20090504195801.GA22677@kroah.com> <20090505094845.6e9b5bab.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505094845.6e9b5bab.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 09:48:45AM +1000, Stephen Rothwell wrote:
> On Mon, 4 May 2009 12:58:01 -0700 Greg Kroah-Hartman <gregkh@suse.de> wrote:
> >
> > From: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > In the near future, the driver core is going to not allow direct access
> > to the driver_data pointer in struct device.  Instead, the functions
> > dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> > have been around since the beginning, so are backwards compatible with
> > all older kernel versions.
> > 
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Cc: Roel Kluin <roel.kluin@gmail.com>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks, I've added this to the patch in my tree.

greg k-h
