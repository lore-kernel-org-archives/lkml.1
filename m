Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbXDJCTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbXDJCTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 22:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966032AbXDJCTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 22:19:19 -0400
Received: from 64-191-130-94.service.qx.net ([64.191.130.94]:33140 "EHLO
	panacea.theblackmoor.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932508AbXDJCTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 22:19:18 -0400
X-Greylist: delayed 1851 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Apr 2007 22:19:18 EDT
Message-ID: <33655.192.168.0.107.1176171513.squirrel@panacea.theblackmoor.net>
In-Reply-To: <20070409185702.bbea2cb9.akpm@linux-foundation.org>
References: <11584.192.146.101.26.1175890435.squirrel@panacea.theblackmoor.net>
    <20070409174700.2e0a14d8.akpm@linux-foundation.org>
    <33389.192.168.0.107.1176169658.squirrel@panacea.theblackmoor.net>
    <20070409185702.bbea2cb9.akpm@linux-foundation.org>
Date: Mon, 9 Apr 2007 22:18:33 -0400 (EDT)
Subject: Re: PROBLEM:  ACPI Thermal Zone for CPU0 does not update after     
     hibernation
From: "Walter Francis" <wally@theblackmoor.net>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Jung-Ik  Lee" <jilee@google.com>,
       linux-acpi@vger.kernel.org
Reply-To: wally@theblackmoor.net
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 9 Apr 2007 21:47:38 -0400 (EDT) "Walter Francis"
> <wally@theblackmoor.net> wrote:
>
>> > On Fri, 6 Apr 2007 16:13:55 -0400 (EDT)
>> > "Walter Francis" <wally@theblackmoor.net> wrote:
>>
>> >> After hibernating, the CPU0 thermal zone never updates.  It will stay at
>> 59C
>> >> forever for example.

> Yes, the above looks like the correct change.

> Strange.  Maybe a timing thing.

> Yes it does.  What happens of you stop and restart the daemon a second
> time?

Same thing, although I reverted the change and it still happens, so I must
have overlooked it before.  Which is odd, because it's right at the end of my
suspend script.  Looked to see if the cpuspeed daemon has updated recently and
it hasn't.  Strange. :)

> fwiw, /proc/acpi/thermal_zone/ATF0/temperature seems to do the right thing
> here.

SMP?  Not sure if it's directly tied to SMP, my other laptop I never could get
to behave when suspending.

If there's any more info I can provide or patches to try, let me know.

-- 
Walter Francis

khayts.us
theblackmoor.net
unlimitedphoto.com

