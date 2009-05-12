Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbZELROk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbZELROk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbZELRNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:13:30 -0400
Received: from kroah.org ([198.145.64.141]:35197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbZELRN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:13:27 -0400
Date: Tue, 12 May 2009 09:43:51 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Roel Kluin <roel.kluin@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       krh@redhat.com, linux1394-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] firewire: remove driver_data direct access of struct
	device
Message-ID: <20090512164351.GI16247@kroah.com>
References: <4A088827.7000907@gmail.com> <4A08B9AD.3030208@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A08B9AD.3030208@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 01:50:05AM +0200, Stefan Richter wrote:
> Roel Kluin wrote:
> > To avoid direct access to the driver_data pointer in struct device, the
> > functions dev_get_drvdata() and dev_set_drvdata() should be used.
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> 
> Greg has this already in his driver core tree.
> 
> BTW Greg, just in case, the patches
> "firewire: remove driver_data direct access of struct device" and
> "ieee1394: remove driver_data direct access of struct device"
> which you posted on April 30 are
> Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Thanks, I've added your acks to the patches.

greg k-h
