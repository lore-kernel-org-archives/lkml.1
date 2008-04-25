Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbYDYMHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbYDYMHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 08:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbYDYMH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 08:07:27 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:58532 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbYDYMH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 08:07:26 -0400
Message-ID: <4811C978.6010508@fr.ibm.com>
Date: Fri, 25 Apr 2008 14:07:20 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Matt Helsley <matthltc@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, Oren Laadan <orenl@cs.columbia.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH 2/5] Container Freezer: Make refrigerator always
 available
References: <20080424064756.643890130@us.ibm.com> <20080424064757.227289200@us.ibm.com> <20080425110456.GF14903@elf.ucw.cz>
In-Reply-To: <20080425110456.GF14903@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> Now that the TIF_FREEZE flag is available in all architectures,
>> extract the refrigerator() and freeze_task() from kernel/power/process.c
>> and make it available to all.
>>
>> The refrigerator() can now be used in a control group subsystem 
>> implementing a control group freezer.
>>
>> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
>> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
>> Tested-by: Matt Helsley <matthltc@us.ibm.com>
> 
> There's no problem with doing this... but you should get some debate
> (with Linus?) whether using freezer for cgroups is sane. 

Yes that's what we are trying to know, is the fake signal mechanism 
used by the freezer something we can build upon ? 

> When that is done, there's no problem with this going in, probably 
> through rafael's patch queue.

OK

> (The first patch -- add freezer for all archs -- is probably
> reasonably to go in ASAP, through akpm or something...)

Thanks,

C.
