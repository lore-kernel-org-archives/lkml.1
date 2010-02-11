Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0BKXjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:39:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:37566 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301Ab0BKXi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:38:57 -0500
Date: Thu, 11 Feb 2010 15:36:12 -0800
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Staging: hv: Add proper versioning to HV
 drivers-Corrected.
Message-ID: <20100211233612.GB10315@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56212E883CB@TK5EX14MBXC118.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56212E883CB@TK5EX14MBXC118.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor nits below:

On Thu, Feb 11, 2010 at 11:02:42PM +0000, Hank Janssen wrote:
> 
> Provide proper versioning information for all HV drivers.
> With removal of build time/date/and Minor number as requested
> By Greg KH
> 
> Cc: Greg Kroah-Hartman         <gregkh@suse.de>
> Signed-off-by: Hank Janssen    <hjanssen@microsoft.com>
> Signed-off-by: Haiyang Zhang   <haiyang@microsoft.com>

Don't line up the <email@domain>, just put only one space, there are a
few hundred thousand examples to look at for the correct formatting :)

> 
>  drivers/staging/hv/VersionInfo.h |   22 +++++++++++++++++++---

You forgot a "---" between the signed-off-by and the diffstat.  If you
use either git or quilt, it will get this correct automagically.  That
infers you used something else, which is quite scary.  What are you
using instead to create patches?

Don't worry, I can edit this by hand when I apply it, and will do so in
a few days when I get to my "to-apply" queue, but in the future, please
don't do this.

thanks,

greg k-h
