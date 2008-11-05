Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYKEQSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYKEQSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYKEQS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:18:28 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:1721 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYKEQS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:18:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tf5Kl5c64xWw/Vb3QGsNonSWNjONY60FLC2HFhwiDdFVRgBKSC8CLH8ZD33l8AhhrI
         dCD+HtFbr4GhZR3PgFyoxqyrDXok9Vq+0alofMvUXBqCB935OGrJsJBy6jo/XkAcKpyF
         xSOH82F3PI2FCNGJzxAP2OitzDPj7X6Ueg7UU=
Date: Wed, 5 Nov 2008 19:11:51 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.28-rc2: REGRESSION in early boot
Message-ID: <20081105161151.GA7286@localhost>
References: <20081104224510.GA7672@mit.edu> <86802c440811041614i5ab5e7f5hf910211ef57423e7@mail.gmail.com> <20081105153508.GB22998@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105153508.GB22998@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Theodore Tso - Wed, Nov 05, 2008 at 10:35:08AM -0500]
| On Tue, Nov 04, 2008 at 04:14:14PM -0800, Yinghai Lu wrote:
| > 
| > please check http://lkml.org/lkml/2008/11/4/431
| > 
| 
| So do you believe that applying this fix will address the failure I
| was seeing?  In a follow up to your thread you replyed to Ben
| Hurchings saying:
| 
| >your patch is still needed...
| >also please add one WARN_ON when nr > NR_IRQS.
| >YH
| 
| Is there some other patch I should look at as well?

I suppose Yinghai meant this one

	http://lkml.org/lkml/2008/11/5/81

ie WARN if we exceed NR_IRQS and abate to the array bound.

| 
| What is your theory for why this was causing a failure in the timer
| subsystem?  Were we overrunning the end of irq_desc array and stomping
| on some other data structure?
| 
| Thanks, regards,
| 
| 						- Ted
| 
		- Cyrill -
