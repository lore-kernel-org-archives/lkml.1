Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575AbZINGdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbZINGdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbZINGdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:33:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZINGdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:33:50 -0400
Message-ID: <4AADE3D0.200@suse.de>
Date: Mon, 14 Sep 2009 08:33:52 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] Disable partition scan
References: <909257926@web.de>
In-Reply-To: <909257926@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> Hello, 
> 
> iirc i had a setup a while ago where i also found disabling partition scanning would be nice to have.
> 
> actually, we have a bugzilla entry for this - have a look at:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8588
> 
> anyway, wouldn`t it be better to disable that on a per device basis or at least be able to exclude 
> the boot/system devices from being skipped? 
> 
Hmm. Not sure about this.
For once, you'd have to have a tool like kpartx anyway to generate the partition mappings for the
not-excluded devices. Hence it's not a big deal to use this tool _always_, ie for all devices.

But more importantly the commandline will be a killer. You would have to specify the device
to be excluded prior to driver probing. Which means you'd have to know how the driver would
enumerate the device and how the device to be excluded would be named.
But exactly this isn't guaranteed, so it'll be virtually impossible to do so.

Cheers,

Hannes
PS.: One wonders what'll happen to the patch. Maybe it'll linger forever in bugzilla as no-one
feels it important enough to have a look at it, let alone merge ...
So, if there are any users out there, please speak up to have it merged!
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
