Return-Path: <linux-kernel-owner+w=401wt.eu-S933692AbXFRXJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692AbXFRXJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764896AbXFRXJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:09:08 -0400
Received: from dvhart.com ([64.146.134.43]:44746 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763117AbXFRXJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:09:07 -0400
X-Greylist: delayed 1647 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 19:09:07 EDT
Message-ID: <46770A22.4020007@mbligh.org>
Date: Mon, 18 Jun 2007 15:41:38 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Natalie Protasevich <protasnb@gmail.com>
Cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to improve the quality of the kernel?
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>	 <200706172053.41806.bzolnier@gmail.com>	 <20070617115258.1f55b29d.akpm@linux-foundation.org>	 <200706172349.08813.bzolnier@gmail.com>	 <4675C083.6080409@s5r6.in-berlin.de>	 <20070617220927.99ebc1ee.akpm@linux-foundation.org>	 <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com>
In-Reply-To: <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> > So if you make changes to random-driver.c you can do `git-log
>> > random-driver.c|grep Tested-by" to find people who can test
>> > your changes for you.
>>
>> You would'nt even need to search in GIT.  Maybie even when ever a
>> patchset is being proposed a mail could be sent to appropriate
>> hardware/or feature pseudo-auto-generated mailing-list?
>>
>> On lkml I mostly try to follow patches/bugs associated with hardware I
>> use.  Why not try to automate the process and get more testers in?
>>
> 
> I think this is an excellent point. One data point could be a field in
> bugzilla to input the hardware information. Simple query can select
> common hardware and platform. So far it's not working when hardware is
> just mentioned in the text part.

if it's free text it'll be useless for search ... I suppose we could
do drop-downs for architecture at least? Not sure much beyond that
would work ... *possibly* the common drivers, but I don't think
we'd get enough coverage for it to be of use.

M.
