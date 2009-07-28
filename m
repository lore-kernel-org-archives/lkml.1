Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZG1VNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZG1VNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZG1VNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:13:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbZG1VNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:13:21 -0400
Date: Tue, 28 Jul 2009 14:12:16 -0700
From: Greg KH <gregkh@suse.de>
To: Jakob Gruber <jakob.gruber@kabelnet.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Missing device IDs in rt2870
Message-ID: <20090728211216.GA12363@suse.de>
References: <20090728230117.8fca2314.jakob.gruber@kabelnet.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728230117.8fca2314.jakob.gruber@kabelnet.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 11:01:17PM +0200, Jakob Gruber wrote:
> >From http://bugzilla.kernel.org/show_bug.cgi?id=13459#c3
> 
> In rt2870.h, there are 2 lists of USB devices. One is within 
> 
> #ifndef RT30xx
> #endif
> 
> and the other in 
> 
> #ifdef RT30xx
> #endif

That kind of implies that the 2870 driver should not support this
device, right?

> 
> Since I'm not sure whether to add the devices to both lists or only the first,
> I'm posting a patch for both variations.
> 
> Patch 1, add devices only to first list:

Well, pick one :)

I'd prefer someone with one of these devices to test the patch and
verify that it works before blindly applying.  Fair enough?

thanks,

greg k-h
