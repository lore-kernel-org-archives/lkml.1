Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYDSIVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYDSIVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 04:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYDSIVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 04:21:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53223 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYDSIVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 04:21:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4809AB57.6050103@s5r6.in-berlin.de>
Date: Sat, 19 Apr 2008 10:20:39 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Frans Pop <elendil@planet.nl>, Yinghai Lu <yhlu.kernel.send@gmail.com>,
       mingo@elte.hu, akpm@linux-foundation.org, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: simplify the memtest parameter setting
References: <200804181749.15782.yhlu.kernel@gmail.com>	 <200804190357.09243.elendil@planet.nl>	 <200804190415.47552.elendil@planet.nl> <86802c440804182017r4fe78371w3a4a714a44591223@mail.gmail.com>
In-Reply-To: <86802c440804182017r4fe78371w3a4a714a44591223@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Apr 18, 2008 at 7:15 PM, Frans Pop <elendil@planet.nl> wrote:
>>  the new description is probably too short.
>>  The phrase "allows memtest to be set" does not really mean anything to a
>>  user who does not know what memtest really does. It also does not explain
>>  that memtest is a boot parameter.
>>
>>  Also, it should probably be made more explicit that no memtest is actually
>>  performed unless the memtest boot parameter is passed at the boot prompt.
>>
>>  Looks like 4 is the maximum possible value. This should be mentioned
>>  explicitly (here as well as in Documentation/kernel-parameters.txt).

To add to this:  The help text should IMO contain
   - that a test for faulty RAM is being added if Y,
   - that this feature can be controlled by the boot parameter
     (and, per the parameter's default, is normally off),
   - how many loops with which data patterns are performed depending
     on the boot parameter value,
   - how long this might take (so that nobody who hears of this for
     the first time enables it e.g. on a server which is supposed to
     not take too long to reboot),
   - how reliable the results of this test are (I presume that some
     faults can only be found by many repeated re-runs of the memory
     tester),
   - that saying Y slightly (?) increases the size of the kernel image
     but does not influence the kernel size after boot-up is completed.

Thanks,
-- 
Stefan Richter
-=====-==--- -=-- =--==
http://arcgraph.de/sr/
