Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbZAHMUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbZAHMUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbZAHMU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:20:26 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34862 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753388AbZAHMUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:20:25 -0500
Date: Thu, 8 Jan 2009 12:20:22 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: david-b@pacbell.net, linux-i2c@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: GPIO: Fix probe() error return in gpio driver probes
Message-ID: <20090108122022.GO12431@fluff.org.uk>
References: <20090107125619.052023040@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107125619.052023040@fluff.org.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 12:56:19PM +0000, ben@fluff.org.uk wrote:
> A number of drivers in drivers/gpio return -ENODEV when confronted
> with missing setup parameters such as the platform data. However,
> returning -ENODEV causes the driver layer to silently ignore the
> driver as it assumes the probe did not find anything and was only
> speculative.
> 
> To make life easier to discern why a driver is not being attached,
> change to returning -EINVAL, which is a better description of the
> fact that the driver data was not valid.
> 
> Also add a set of dev_dbg() statements to the error paths to provide
> an better explanation of the error as there may be more that one point
> in the driver.

sorry, sent from the wrong email address please ignore.
-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
