Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbZA3Gks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbZA3Gks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 01:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZA3Gkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 01:40:40 -0500
Received: from mout.perfora.net ([74.208.4.195]:53021 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbZA3Gkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 01:40:39 -0500
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Nathanael Hoyle <nhoyle@hoyletech.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr>
References: <1233294584.28741.2.camel@localhost>
	 <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 01:40:35 -0500
Message-Id: <1233297635.17301.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+5dWNi87E2gkpu6QzmsAknJEDGcjX3wTU3RcZ
 D9qSTp7B/GmKIBN09Z4LavxpsoK7TomXXH5vl/2IzD5GgMH3CW
 0KztMD5o+yOMm36I5H4QwgBeRVdYhMn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 07:16 +0100, Jan Engelhardt wrote:
> On Friday 2009-01-30 06:49, Nathanael Hoyle wrote:
> >
> >I have done a bit of research on how the kernel scheduler works, and
> >why I am seeing this behavior. I had previously, apparently
> >ignorantly, equated 'nice 19' with being akin to Microsoft Windows'
> >'idle' thread priority, and assumed it would never steal CPU cycles
> >from a process with a higher(lower, depending on nomenclature)
> >priority. [...]
> >
> >One[...] is to alter the semantics of nice 19 such that it does not
> >boost. Since this would break existing assumptions and code, I do
> >not think it is feasible. [...] Finally, new scheduling classes
> >could be introduced[...]
> 
> Surprise. There is already SCHED_BATCH (intended for computing tasks
> as I gathered) and SCHED_IDLE (for idle stuff).
> 

The one discussion I saw referencing SCHED_BATCH seemed to imply that it
was a non-standard kernel patch by Con Kolivas in one of his -ck
variants that never made it into mainline and is not being maintained.
Is this inaccurate?

I was unfamiliar with SCHED_IDLE. Having done a little Googling now, I
finally find reference to the man page for sched_setscheduler(2). This
appears that it is likely what I wanted.

I think the information I had been able to find was somehwat out of
date. It had indicated that the only static priority levels were the
realtime ones.

Is there currently a standardized userspace tool to use to run a command
in order to alter its scheduling class? Obviously writing one would be
trivial, but didn't know if something like:

$ runidle ./foldingathome

would be available.

Thanks for your helpful reply.

> 
> 
> >Please make the obvious substitution to my email address in order to 
> >bypass the spam-killer.
> 
> (Obviously this is not obvious... there are no 'nospam' keywords or 
> similar in it that could be removed.)

I made a failed attempt to post earlier in the evening, which included
the address 'nhoyle@no-damn-spam.hoyletech.com'. When that one didn't
make it to the list (though I'm unsure it had to do with the address I
used) I retried with the clean address.  I forgot to remove the note at
the bottom of the posting.

Sincerely,
Nathanael Hoyle

