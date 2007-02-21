Return-Path: <linux-kernel-owner+w=401wt.eu-S1423092AbXBUUYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423092AbXBUUYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423094AbXBUUYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:24:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423092AbXBUUYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:24:35 -0500
Message-ID: <45DCA9CC.1070208@redhat.com>
Date: Wed, 21 Feb 2007 15:21:32 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com>	<20070221114737.a09be761.akpm@linux-foundation.org> <m1odnn1d7n.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1odnn1d7n.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
>> On Wed, 21 Feb 2007 14:31:41 -0500
>> Chuck Ebbert <cebbert@redhat.com> wrote:
>>> What is the status of:
>>>
>>>
>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-simplfy-__assign_irq_vector.patch
>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch
>>
>> That's mainly an Andi decision.  Let's cc him.
>>
>>> They fix a serious bug that causes machines to freeze up
>>> or just run very slowly.
>>>
>>> I'd like to see these in -stable if possible.
>> They're not even in mainline yet.
> 
> If you don't have it you at least want the patch below.  It generally
> makes the bug non-fatal.
> 
> I'm still working my way through possible fixes...  Although the
> patch in question is close, and normally fixes it in my utmost
> paranoia I can still find problems with it.

We've tested it and found no problems so far.  It's definitely
better than what's there now. :)
