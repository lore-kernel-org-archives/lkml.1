Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbZHOQUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbZHOQUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 12:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbZHOQUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:20:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60847 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbZHOQUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:20:51 -0400
Date: Fri, 14 Aug 2009 18:32:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Tippett, Matthew" <Matthew.Tippett@amd.com>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Li, Samuel" <Samuel.Li@amd.com>
Subject: Re: [PATCH][ACPI] AC/DC notifier
Message-ID: <20090814163233.GC1626@ucw.cz>
References: <FFAE0590FF35E441901B67BD8BA62E950245ABD9@storexmb3.amd.com> <20090812005532.GA31003@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812005532.GA31003@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-08-12 01:55:32, Matthew Garrett wrote:
> On Tue, Aug 11, 2009 at 08:51:49PM -0400, Tippett, Matthew wrote:
> 
> >    From a graphics perspective (your area of expertise), this will allow KMS
> >    drivers to do some more intelligent actions based on the ac/dc state. 
> >    Some examples of this could be improving the power consumption of the
> >    graphics hardware through adapting clock memory/engine settings for
> >    reduced power consumption, reducing refresh rate of the display to reduce
> >    scanout memory access, adjusting backlight brightness, etc.
> 
> Right. As you say, my concern is that most of this should belong in 
> userspace. Where we risk hardware damage there's an obvious argument for 
> doing this in kernel, but we should ensure that that's limited to 
> whatever coarse-grain handling is absolutely required rather than doing 
> things like touching display brightness.

Yep... Some may want to save power even when AC is online -- like when
running on UPS. Some may want max performmance even on battery. 
								Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
