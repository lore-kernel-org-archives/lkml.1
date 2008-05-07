Return-Path: <linux-kernel-owner+w=401wt.eu-S1764722AbYEGTAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764722AbYEGTAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932687AbYEGS7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:59:42 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37590 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764240AbYEGS7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:59:40 -0400
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion
	from 2.6.24)
From: John Stultz <johnstul@us.ibm.com>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org, Chris McDermott <lcm@us.ibm.com>
In-Reply-To: <572961.18046.qm@web32607.mail.mud.yahoo.com>
References: <572961.18046.qm@web32607.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Wed, 07 May 2008 11:59:38 -0700
Message-Id: <1210186778.16386.5.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-07 at 11:14 -0700, Martin Knoblauch wrote:
> > The printk timestamps may jump around a bit at bootup,  especially if
> > you have unsynced TSCs, so that is a known issue. However its not
> > known to have any actual negative effect other then maybe causing the
> > dmesg log to be a bit confusing.
> > 
> 
>  the problem, is not just at bootup and the jumping. During the
> *complete* lifetime of the kernel I see:
> 
> a) the dmesg timestamps jumping back and forth
> b) the values are much to small and have absolutely no relation to
> "seconds after bootup", as they have with 2.6.24 and before.
> 
>  But you are right, it might not be a jiffie problem, but a "dmesg
> timestamp" thing.

Hrmm.. So the issue persisting over the lifetime of the kernel is a new
one by me. This may also have some effect in scheduling decisions (not
necessarily causing a correctness issue, but a performance one). Also it
may have some effect on thread cputime values.

Please do open a bug and provide example dmesg output. I'll try to tag
some folks who have access to the same system type. 

thanks
-john


