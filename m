Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbXDMNgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbXDMNgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbXDMNgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:36:11 -0400
Received: from vscan02.westnet.com.au ([203.10.1.132]:51054 "EHLO
	vscan02.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbXDMNgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:36:10 -0400
X-Greylist: delayed 2023 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2007 09:36:10 EDT
Message-ID: <461F7F5F.1040206@snapgear.com>
Date: Fri, 13 Apr 2007 23:02:23 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 68328serial & pm_register
References: <20070413073720.GA14437@lst.de>
In-Reply-To: <20070413073720.GA14437@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Christoph,

Christoph Hellwig wrote:
> 68328serial is the last driver to call pm_register and thus using and
> keeping alive the really old PM scheme.  Any chance to convert it over
> to platform devices (which would also clean up a lot of the ifdef
> mess in the driver), or simply rip out that rudimentary PM support?

I don't have any hardware that uses this, I can only compile test it.
The occassional patch I submit for it is just to keep it compiling.
But I am happy to take out what PM support it has.


> On a less urgent basis, is there any chance to convert the driver
> to use serial_core, which it doesn't despite living in drivers/serial?

I'd have to leave that to someone with hardware.

Regards
Greg



-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
