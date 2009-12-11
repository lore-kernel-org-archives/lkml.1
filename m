Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZLKDre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZLKDre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbZLKDrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:47:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbZLKDrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:47:32 -0500
Date: Thu, 10 Dec 2009 19:47:11 -0800
From: Greg KH <gregkh@suse.de>
To: David Brownell <david-b@pacbell.net>
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, dsilvers@simtec.co.uk, ben@simtec.co.uk,
       Artem.Bityutskiy@nokia.com, akpm@linux-foundation.org
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use
	gpioN for device names
Message-ID: <20091211034711.GA2773@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com> <8859db84eb13c0056e20c5edd5dba6837cb60c27.1260364108.git.ext-jani.1.nikula@nokia.com> <200912101939.30446.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912101939.30446.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 07:39:30PM -0800, David Brownell wrote:
> On Wednesday 09 December 2009, Jani Nikula wrote:
> > While the device names are now unique again, collisions in chip->names
> > will still prevent duplicates from being exported to sysfs.
> 
> That's why I was never a real fan of chip->names...
> 
> IMO a "good" solution in this space needs to accept that
> those names are not going to be globally unique ... but
> that they'll be unique within some context, of necessity.
> 
> If Greg doesn't want to see those names under classes,
> so be it ... but where should they then appear?

As a sysfs file within the device directory called 'name'?  Then just
grep through the tree to find the right device, that also handles
duplicates just fine, right?

thanks,

greg k-h
