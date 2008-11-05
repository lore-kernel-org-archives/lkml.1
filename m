Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYKEPf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYKEPf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 10:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYKEPfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 10:35:12 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48196 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751639AbYKEPfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 10:35:11 -0500
Date: Wed, 5 Nov 2008 10:35:08 -0500
From: Theodore Tso <tytso@mit.edu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.28-rc2: REGRESSION in early boot
Message-ID: <20081105153508.GB22998@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>
References: <20081104224510.GA7672@mit.edu> <86802c440811041614i5ab5e7f5hf910211ef57423e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440811041614i5ab5e7f5hf910211ef57423e7@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 04:14:14PM -0800, Yinghai Lu wrote:
> 
> please check http://lkml.org/lkml/2008/11/4/431
> 

So do you believe that applying this fix will address the failure I
was seeing?  In a follow up to your thread you replyed to Ben
Hurchings saying:

>your patch is still needed...
>also please add one WARN_ON when nr > NR_IRQS.
>YH

Is there some other patch I should look at as well?

What is your theory for why this was causing a failure in the timer
subsystem?  Were we overrunning the end of irq_desc array and stomping
on some other data structure?

Thanks, regards,

						- Ted




