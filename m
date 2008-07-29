Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYG2DSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYG2DSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYG2DSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:18:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:39137 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYG2DSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:18:34 -0400
Date: Mon, 28 Jul 2008 20:17:52 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Collins <ben.collins@canonical.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 5/7] [airprime] Add support for more devices
Message-ID: <20080729031752.GA11980@suse.de>
References: <24762.90.138.930.038.1036103001.ben.collins@canonical.com> <E1KKl4J-00068N-2b@swissweb.swissdisk.com> <20080728195813.6c51450b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728195813.6c51450b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 07:58:13PM -0700, Andrew Morton wrote:
> On Sun, 20 Jul 2008 21:54:48 -0400 Ben Collins <ben.collins@canonical.com> wrote:
> 
> > Reference: https://launchpad.net/bugs/208250
> > 
> > Add support for:
> > - Audiovox PC5740
> > - Huawei E220
> > - Momo design
> > - AirPrime 5220
> > - Dell Wireless HSDPA 5500
> > - Sprint Pantech PX-500
> > - Novatel U727
> > - Onda MT505UP
> 
> airprime.c got deleted.

Ben, why did you not cc: the linux-usb mailing list if you are sending
USB patches out?  Or at least the USB or USB-serial maintainer :)

>   commit 640c1bce86d1e11ee6a1263fdf6170d3210b1684
>   Author: Greg Kroah-Hartman <gregkh@suse.de>
>   Date:   Thu Jun 19 11:21:16 2008 -0700
> 
>       USB: delete airprime driver
>     
>       This driver is only for one device id, and the option driver should be
>       used instead for it.
> 
> It'd be good if we can verify that the option driver presently supports
> all these new devices.

If it doesn't, it should be very simple to add the device ids to it.

airprime.c is dead and gone.

thanks,

greg k-h
