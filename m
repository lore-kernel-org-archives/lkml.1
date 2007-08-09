Return-Path: <linux-kernel-owner+w=401wt.eu-S940626AbXHIRXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940626AbXHIRXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934322AbXHIRXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:23:31 -0400
Received: from phoenix.bawue.net ([193.7.176.60]:56188 "EHLO mail.bawue.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765642AbXHIRXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:23:30 -0400
Date: Thu, 9 Aug 2007 18:41:52 +0200
From: Joerg Sommrey <jo@sommrey.de>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] bad temperature values from w83781d in 2.6.22
Message-ID: <20070809164152.GA28404@sommrey.de>
Mail-Followup-To: Joerg Sommrey <jo@sommrey.de>,
	"Mark M. Hoffman" <mhoffman@lightlink.com>,
	LKML <linux-kernel@vger.kernel.org>,
	lm-sensors <lm-sensors@lm-sensors.org>
References: <20070805183219.0d54802b.akpm@linux-foundation.org> <20070808010316.GB3584@jupiter.solarsys.private> <20070808151716.GA6053@sommrey.de> <20070809035642.GE3584@jupiter.solarsys.private> <20070809070915.GA24252@sommrey.de> <20070809122619.GF3584@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809122619.GF3584@jupiter.solarsys.private>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Aug 09, 2007 at 08:26:19AM -0400, Mark M. Hoffman wrote:
> Hi Joerg:
> 
> > On Wed, Aug 08, 2007 at 11:56:42PM -0400, Mark M. Hoffman wrote:
> > > Thanks for sending all that.  I see one bug clearly, and I'm pretty close to
> > > seeing the other one.  But for tonight, I need sleep.
> 
> There's just one bug after all.  The second was a figment of my sleep-deprived
> imagination.
> 
[...]
> 
> My bad, there's a second i2cset command that would have done it.  Please try
> this patch against v2.6.22.
> 

Great, problem fixed.  Thanks a lot for your prompt solution!

-jo

-- 
-rw-r--r-- 1 jo users 62 2007-08-09 08:46 /home/jo/.signature
