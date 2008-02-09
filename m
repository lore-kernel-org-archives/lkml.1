Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbYBIACr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbYBIACr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760262AbYBIACe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:02:34 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:52965 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760245AbYBIACb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:02:31 -0500
Message-ID: <47ACED2F.30006@oracle.com>
Date: Fri, 08 Feb 2008 16:00:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dtor@insightbb.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] [git pull] Input updates for 2.6.25-rc0
References: <200802060108.31644.dtor@insightbb.com>	<20080208232536.GA15727@elte.hu>	<20080208152812.2bb14374@extreme>	<20080208153741.54409a7a.randy.dunlap@oracle.com> <20080208155459.fdbcf610.akpm@linux-foundation.org>
In-Reply-To: <20080208155459.fdbcf610.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 8 Feb 2008 15:37:41 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>>> I think someone already sent a patch to select the LEDS
>> I did... and more.  Who will merge it?  (below)
>>
>> ---
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Add I2C to config since the driver makes several i2c*() calls.
>>
>> Add to help text that the Intel I2C ICH (i801) driver is also needed
>> for this kernel.
>>
>> Add LEDS_CLASS to config since the driver makes les_classdev_*() calls:
>> ERROR: "led_classdev_register" [drivers/input/misc/apanel.ko] undefined!
>> ERROR: "__led_classdev_unregister" [drivers/input/misc/apanel.ko] undefined!
> 
> I have assumed that Dmitry will be handling this one.

Yes, that would be it's normal route, but when builds are easily broken,
it would be nice to have a fast-track mechanism...

But then I (we?) still think that people should use Documentation/SubmitChecklist
etc. also.  :(

-- 
~Randy
