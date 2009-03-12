Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZCLSMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZCLSMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbZCLSMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:12:33 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:35349 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZCLSMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:12:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hRZVzj7TnoWR0vqAC61HqiHTnnICiRnlkXoz5/UD/zXf2SfCc7nn1Cr0fNDg6d+8E8
         /ZunTfGV7CtKjFT9axvXACFBml1ytMgfGp1qNsJZXbfzibKq1T1A7tv2nN9Gj6mfxYzK
         /TX8W0caeRsKHHvlY2yE+IfW3gBbwTbwRcrjo=
Date: Thu, 12 Mar 2009 14:12:25 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: Chris Brannon <cmbrannon@cox.net>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
Message-ID: <20090312181225.GC26099@tuxbookpro.rit.edu>
References: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net> <1f1b08da0903061456g7621f92cx8a1e251249d739ac@mail.gmail.com> <20090307162327.PQGL18213.eastrmmtao106.cox.net@eastrmimpo02.cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090307162327.PQGL18213.eastrmmtao106.cox.net@eastrmimpo02.cox.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 10:23:05AM -0600, Chris Brannon wrote:
> John Stultz wrote:
> > On Tue, Mar 3, 2009 at 7:06 PM, Christopher Brannon <cmbrannon@cox.net> wrote:
> > > I implemented such a facility for Linux.  A read of /dev/time produces
> > > four decimal numbers: epoch seconds, nanoseconds since start of epoch,
> > > jiffies since boot, and jiffies per second.
> > 
> > Ehh. Why would we want to export raw kernel internal values like
> > jiffies and HZ?
> > 
> > I think the CLOCK_MONOTONIC clockid would probably be a better value to export.
> 
> I'll look at CLOCK_MONOTONIC clockid.  I'm more than glad to export something
> more appropriate, including nothing at all (dummy values, perhaps).

Chris, are the current values exactly what one would get if reading /dev/time on
Plan 9? If possible, it would be nice to aim for 100% compatibility as there are
folks trying to get complete Plan 9 binary compatibility working in Linux.

> 
> -- Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
				J.R. Mauro

()  ascii ribbon campaign - against html e-mail 
/\  www.asciiribbon.org   - against Microsoft attachments
