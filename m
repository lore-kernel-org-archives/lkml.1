Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbZGUBZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbZGUBZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZGUBZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:25:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33115 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZGUBZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:25:11 -0400
Date: Mon, 20 Jul 2009 21:25:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Johannes Berg <johannes@sipsolutions.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: event tracing, ringbuffer and RB_MAX_SMALL_DATA
In-Reply-To: <4A5E78EA.60903@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907202124490.11494@gandalf.stny.rr.com>
References: <1247591891.7178.20.camel@johannes.local>  <4A5D2BF6.6010802@cn.fujitsu.com> <1247651305.14973.3.camel@johannes.local> <4A5E78EA.60903@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Jul 2009, Li Zefan wrote:

> Johannes Berg wrote:
> > On Wed, 2009-07-15 at 09:08 +0800, Li Zefan wrote:
> > 
> >> Right, the length of a dynamic array is not recorded, and this
> >> causes 2 problems:
> >>
> >> - the event filter is not working properly for dynamic strings
> >> - userspace parsers can't figure out the length of those arrays
> >>
> >> I had an idea some time ago, and hopefully will send out a
> >> patch today or tomorrow. 
> > 
> > Well except for the corner case I pointed out, you can determine the
> > length of dynamic arrays by either
> >  - the next dynamic array's offset or
> >  - the length of the item.
> > 
> > So, afaict, the simplest solution would be to not embed the length of
> > the item in type_len if it's not divisible by four and contains dynamic
> > members, though the latter condition might be hard to check.
> > 
> 
> Actually I'm going to encode the size of a dynamic array
> in it's @offset, so the lower 16bits is offset and the
> higher 16bits is size.

Was there a patch sent out to do this yet, or is this still something 
being worked on?

Thanks,

-- Steve

