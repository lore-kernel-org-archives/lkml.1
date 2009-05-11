Return-Path: <linux-kernel-owner+w=401wt.eu-S1759670AbZEKVmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbZEKVmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757832AbZEKVlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:41:51 -0400
Received: from kroah.org ([198.145.64.141]:60441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbZEKVlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:41:50 -0400
Date: Mon, 11 May 2009 14:05:58 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, Paul Mackerras <paulus@samba.org>,
       Matthias Fuchs <mfuchs@ma-fu.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of_serial: remove driver_data direct access of struct
	device
Message-ID: <20090511210558.GC31999@kroah.com>
References: <20090504201323.GA23069@kroah.com> <20090505095332.f9c9fbd1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505095332.f9c9fbd1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 09:53:32AM +1000, Stephen Rothwell wrote:
> On Mon, 4 May 2009 13:13:23 -0700 Greg Kroah-Hartman <gregkh@suse.de> wrote:
> >
> > From: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > In the near future, the driver core is going to not allow direct access
> > to the driver_data pointer in struct device.  Instead, the functions
> > dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> > have been around since the beginning, so are backwards compatible with
> > all older kernel versions.
> > 
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Matthias Fuchs <mfuchs@ma-fu.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks, I've added this to the patch in my tree.

greg k-h
