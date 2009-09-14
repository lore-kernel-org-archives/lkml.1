Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbZINU7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbZINU7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZINU7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:59:49 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:58253 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbZINU7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:59:49 -0400
Date: Mon, 14 Sep 2009 22:59:50 +0200
Message-Id: <912126502@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Hannes Reinecke <hare@suse.de>
Cc: linux-kernel@vger.kernel.org, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] Disable partition scan
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18ludoRz7YhvwXdj5SqlS8iwTFpa38YObV5Snm/Pvf/gnEqa
 rxzsYWY37qBhLLVzaPMc8D0R4Dkc0jELraCGqMuF3gYcWiUOY0=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But more importantly the commandline will be a killer. You would have to specify the device
> to be excluded prior to driver probing. Which means you'd have to know how the driver would
> enumerate the device and how the device to be excluded would be named.
> But exactly this isn't guaranteed, so it'll be virtually impossible to do so.

ok, you`re right

>PS.: One wonders what'll happen to the patch. Maybe it'll linger forever in bugzilla as no-one
>feels it important enough to have a look at it, let alone merge ...
>So, if there are any users out there, please speak up to have it merged!

you did that patch for a reason (customer request?) and we have another request for it in bugzilla.
i think it`s useful.

maybe adding the new param to kernel-params.txt and adding some more people cc below the 
signed-off will raise chances for acceptance.


> devzero@web.de wrote:
> > Hello, 
> > 
> > iirc i had a setup a while ago where i also found disabling partition scanning would be nice to have.
> > 
> > actually, we have a bugzilla entry for this - have a look at:
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=8588
> > 
> > anyway, wouldn`t it be better to disable that on a per device basis or at least be able to exclude 
> > the boot/system devices from being skipped? 
> > 
> Hmm. Not sure about this.
> For once, you'd have to have a tool like kpartx anyway to generate the partition mappings for the
> not-excluded devices. Hence it's not a big deal to use this tool _always_, ie for all devices.
> 
> But more importantly the commandline will be a killer. You would have to specify the device
> to be excluded prior to driver probing. Which means you'd have to know how the driver would
> enumerate the device and how the device to be excluded would be named.
> But exactly this isn't guaranteed, so it'll be virtually impossible to do so.
> 
> Cheers,
> 
> Hannes
> PS.: One wonders what'll happen to the patch. Maybe it'll linger forever in bugzilla as no-one
> feels it important enough to have a look at it, let alone merge ...
> So, if there are any users out there, please speak up to have it merged!
> -- 
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: Markus Rex, HRB 16746 (AG Nürnberg)
> 


________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

