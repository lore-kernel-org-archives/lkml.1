Return-Path: <linux-kernel-owner+w=401wt.eu-S1751656AbXBVPmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbXBVPmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXBVPmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:42:01 -0500
Received: from brick.kernel.dk ([62.242.22.158]:4985 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbXBVPmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:42:00 -0500
Date: Thu, 22 Feb 2007 16:41:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Mark Lord <liml@rtr.ca>
Cc: Jeff Garzik <jeff@garzik.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] libata: add NCQ blacklist entries from Silicon Image   Windows driver
Message-ID: <20070222154156.GB4740@kernel.dk>
References: <45DD2EC9.4050403@shaw.ca> <45DD3EC7.3050801@garzik.org> <20070222113226.GI5549@kernel.dk> <45DDAB95.6070903@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DDAB95.6070903@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22 2007, Mark Lord wrote:
> Jens Axboe wrote:
> >>Robert Hancock wrote:
> >..
> >>>+    /* The following blacklist entries are taken from the Windows
> >>>+       driver .inf files for the Silicon Image 3124 and 3132. */
> >>>+    { "Maxtor 7B250S0",    "BANC1B70",    ATA_HORKAGE_NONCQ, },
> >>>+    { "HTS541060G9SA00",    "MB3OC60D",    ATA_HORKAGE_NONCQ, },
> >>>+    { "HTS541080G9SA00",    "MB4OC60D",    ATA_HORKAGE_NONCQ, },
> >>>+    { "HTS541010G9SA00",    "MBZOC60D",    ATA_HORKAGE_NONCQ, },
> >>Do we have information that these drives fail on non-SiI controllers?
> >>
> >>Sometimes the problem can be related to a single family of controllers.
> >
> >I don't know about the Hitachi's, but the Maxtor with that firmware is
> >definitely broken. It _appeared_ to work if the depth was limited to 4,
> >but I didn't test it long enough to be absolutely certain. So the safest
> >is indeed to blacklist it.
> 
> Yes, broken on the Silicon Image controllers for sure.
> But what type of controller did you observe the failures on, Jens ?

achi

-- 
Jens Axboe

