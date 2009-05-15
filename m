Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZERN2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZERN2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 09:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZERN1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 09:27:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33142 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZERN1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 09:27:54 -0400
Date: Fri, 15 May 2009 21:58:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>
Subject: Re: [patch 02/13] Driver Core: misc: add nodename support for misc
	devices.
Message-ID: <20090515195856.GD1353@ucw.cz>
References: <20090509142601.874865281@blue.kroah.org> <20090509143631.755885703@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509143631.755885703@blue.kroah.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-05-09 07:26:03, Greg KH wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> This adds support for misc devices to report their requested nodename to
> userspace.  It also updates a number of misc drivers to provide the
> needed subdirectory and device name to be used for them.
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Maybe it would be better to assign stable minor/major numbers to those
devices instead? minor/major number space is pretty big these days...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
