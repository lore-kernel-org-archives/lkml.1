Return-Path: <linux-kernel-owner+w=401wt.eu-S932539AbXH3Qyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbXH3Qyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932091AbXH3Qy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:54:28 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:52122 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434AbXH3QyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:54:23 -0400
Message-ID: <46D6F4D0.6040401@gmail.com>
Date: Thu, 30 Aug 2007 18:48:16 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: keith.packard@intel.com, Ingo Molnar <mingo@elte.hu>,
       Al Boldi <a1426z@gawab.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Subject: Re: CFS review
References: <200708111344.42934.a1426z@gawab.com>	 <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu>	 <200708280737.53439.a1426z@gawab.com> <20070829041827.GA8733@elte.hu>	 <1188361749.21502.123.camel@koto.keithp.com>	 <20070829044614.GA13225@elte.hu>	 <1188374249.21502.155.camel@koto.keithp.com>	 <20070829080417.GB19386@elte.hu> <1188403075.21502.158.camel@koto.keithp.com> <46D5CF5F.6090505@gmail.com> <46D6EAFA.7070304@redhat.com>
In-Reply-To: <46D6EAFA.7070304@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2007 06:06 PM, Chuck Ebbert wrote:

> On 08/29/2007 03:56 PM, Rene Herman wrote:

>> Before people focuss on software rendering too much -- also with 1.3.0
>> (and a Matrox Millenium G550 AGP, 32M) glxgears also works decidedly
>> crummy using hardware rendering. While I can move the glxgears window
>> itself, the actual spinning wheels stay in the upper-left corner of the
>> screen and the movement leaves a non-repainting trace on the screen.
>> Running a second instance of glxgears in addition seems to make both
>> instances unkillable -- and when I just now forcefully killed X in this
>> situation (the spinning wheels were covering the upper left corner of
>> all my desktops) I got the below.
>> 
>> Kernel is 2.6.22.5-cfs-v20.5, schedule() is in the traces (but that may
>> be expected anyway).

> And this doesn't happen at all with the stock scheduler? (Just confirming,
> in case you didn't compare.)

I didn't compare -- it no doubt will. I know the title of this thread is 
"CFS review" but it turned into Keith Packard noticing glxgears being broken 
on recent-ish X.org. The start of the thread was about things being broken 
using _software_ rendering though, so I thought it might be useful to 
remark/report glxgears also being quite broken using hardware rendering on 
my setup at least.

>> BUG: unable to handle kernel NULL pointer dereference at virtual address
>> 00000010
>>  printing eip:
>> c10ff416
>> *pde = 00000000
>> Oops: 0000 [#1]
>> PREEMPT
> 
> Try it without preempt?

If you're asking in a "I'll go debug the DRM" way I'll go dig a bit later 
(please say) but if you are only interested in the thread due to CFS, note 
that I'm aware it's not likely to have anything to do with CFS.

It's not reproducable for you? (full description of bug above).

Rene.
