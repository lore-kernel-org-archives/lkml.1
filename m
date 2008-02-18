Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYBRVcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYBRVcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYBRVcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:32:41 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48472 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbYBRVck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:32:40 -0500
Date: Mon, 18 Feb 2008 13:32:34 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH] adt7473: New driver for Analog Devices
	ADT7473 sensor chip
Message-ID: <20080218213234.GC5784@tree.beaverton.ibm.com>
References: <20071219034116.GM6870@tree.beaverton.ibm.com> <20071219154759.7be5025c@hyperion.delvare> <20071219231437.GR6870@tree.beaverton.ibm.com> <20080217200250.GD2916@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217200250.GD2916@jupiter.solarsys.private>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 03:02:50PM -0500, Mark M. Hoffman wrote:

> Documentation/hwmon/adt7473 would be nice.

Ok, I'll generate one.

> That should be const.

Applied.

> > +	BUG();
> 
> Given ADT7473_PWM_BHVR_SHIFT is 5, this BUG() is obviously impossible.
> But I guess it's not obvious to GCC.

I'll put in a comment to explain that.

> NACK on that comment and associated code:  Jean Delvare submitted a
> patch to NVIDIA over two years ago to fix their bug.  Apparently some
> distros even carry his patch.  So, I don't want to encourage such a
> hack to persist.  Please just do the standard check here.

Ok.  I wonder if the nouveau people have any intention to
reverse-engineer the i2c controller?

Updated patch to follow soon.

--D
