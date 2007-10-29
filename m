Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbXJ2XIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbXJ2XIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXJ2XIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:08:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53832 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbXJ2XIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:08:45 -0400
Message-ID: <472667F3.3000505@garzik.org>
Date: Mon, 29 Oct 2007 19:08:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Randy Dunlap <rdunlap@xenotime.net>, hch@infradead.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create instrumentation directory (git repository)
References: <20071029215138.GA4233@Krystal> <20071029154741.cb093f55.rdunlap@xenotime.net> <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal>
In-Reply-To: <20071029230409.GB16943@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Jeff Garzik (jeff@garzik.org) wrote:
>> Randy Dunlap wrote:
>>> On Mon, 29 Oct 2007 17:51:38 -0400 Mathieu Desnoyers wrote:
>>>
>>>> Hi,
>>>>
>>>> Since we already have the Instrumentation menu in
>>>> kernel/Kconfig.instrumentation and instrumentation code all over the
>>>> kernel tree:
>>>>
>>>> arch/*/oprofile/*.c
>>>> kernel/kprobes.c
>>>> arch/*/kernel/kprobes.c
>>>> kernel/marker.c
>>>> kernel/profile.c
>>>> kernel/lockdep.c
>>>> vm/vmstat.c
>>>> block/blktrace.c
>>>> drivers/base/power/trace.c
>>>>
>>>> We could move them to
>>>>
>>>> instrumentation/
>>>> arch/*/instrumentation/
>>>>
>>>> Therefore, we could also move the kprobes and marker samples under
>>>>
>>>> instrumentation/samples/
>>>>
>>>> Here is a link to a git repository containing the changes, based on
>>>> 2.6.24-rc1:
>>>>
>>>> git://ltt.polymtl.ca/linux-2.6-instrumentation.git 
>>>> instrumentation-for-linus
>>>> (the interesting range is : v2.6.24-rc1..instrumentation-for-linus)
>>>>
>>>> Through the gitweb interface:
>>>> http://ltt.polymtl.ca/cgi-bin/gitweb.cgi?p=linux-2.6-instrumentation.git
>>>>
>>>> Feedback is appreciated. Sorry for the huge CC list, but the change
>>>> involves many maintainers.
>>> Two more added.  Jeff Garzik and Christoph H. sometimes have some comments
>>> about this.
>>>
>>> It would be helpful if we could get comments on this in the next day
>>> or two [instead of in 1-2 weeks].
>> "instrumentation" is long, and painful to the fingers :)
>>
> 
> Quoting my post from last week:
> 
>> My main concern is that 15 characters long directory name might be
>> inelegant (however, it only beats Documentation by 2).
> 
> And quoting the answer from Valdis.Kletnieks@vt.edu :
> How so?  i n s esc.  4 keystrokes (and still 2 more than D<ESC> ;)
> 
> 
> 
> Better suggestions are wery welcome. However, in modern shells,
> auto-completion is cheap nowadays.

That is no excuse for extreme verbosity.  It makes ls(1) displays ugly, 
it makes diffstat ugly, it causes long pathnames to be truncated in 
various display-oriented programs.

Pick a shorter word like probes or profile or what... or better yet... 
just leave most things in their current directories.

Shuffling files around just to put them into directories with extra-long 
names is highly undesirable.

	Jeff


