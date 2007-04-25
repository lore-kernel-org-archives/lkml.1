Return-Path: <linux-kernel-owner+w=401wt.eu-S1031140AbXDYUzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031140AbXDYUzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031143AbXDYUzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:55:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:14531 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031140AbXDYUzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lTpIvO3tZnzxWpbYBqJRGtJduy1pfwSypxoUaT2zgrl8tza5CTQDIGdSh8XV9FENBSG2Lfu7oR0Ur75kmGBuXz5ph/x2NOyYz1K9zXqM/eL11Hkmi19DwB3xF97zGxyYoO5oycP/K9/KaNjHJyT0G7ZKKGYvMO0PQe3qUpHQY60=
Message-ID: <6bffcb0e0704251355r6de26273s47ba5c857ed0f129@mail.gmail.com>
Date: Wed, 25 Apr 2007 22:55:36 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200704252248.03243.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net>
	 <462FB8E6.9070501@googlemail.com> <462FBD44.2040103@goop.org>
	 <200704252248.03243.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/07, Andi Kleen <ak@suse.de> wrote:
> On Wednesday 25 April 2007 22:42:44 Jeremy Fitzhardinge wrote:
> > Michal Piotrowski wrote:
> > > Timing information is broken
> > >
> >
> > This looks like Andi's sched_clock stuff hitting: it returns an
> > inherently per-cpu result, so using it for printk timestamps isn't very
> > useful.
>
> It should actually roughly work. There can be some drift, but there shouldn't
> be that much error. All CPUs should tick at roughly the same rate because
> it's scaled to nanoseconds
>
> If the drift is a big issue it would also be possible to resync every minute
> or so, but I haven't implemented that.
>
> There will be always some minor monotonicities because it won't try
> to stop the CPU from reordering instructions.
>
> I don't know why it is that off in your case.

Maybe because it's P4 HT?

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
