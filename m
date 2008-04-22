Return-Path: <linux-kernel-owner+w=401wt.eu-S1762047AbYDVVVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047AbYDVVVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbYDVVVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:21:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:53972 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbYDVVVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:21:01 -0400
Message-ID: <480E567B.6060708@windriver.com>
Date: Tue, 22 Apr 2008 16:19:55 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Randy Dunlap <RANDY.DUNLAP@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: kgdb: core
References: <200804181741.m3IHfTeC012089@hera.kernel.org>	<20080418150930.476ea7aa.akpm@linux-foundation.org>	<20080421141252.GR9554@elte.hu>	<20080421214636.617970c6.akpm@linux-foundation.org>	<20080422082519.62adc7f1.randy.dunlap@oracle.com> <20080422135716.c6ee339b.akpm@linux-foundation.org> <5739699.1208898133855.JavaMail.oracle@acsmt302.oracle.com>
In-Reply-To: <5739699.1208898133855.JavaMail.oracle@acsmt302.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2008 21:19:44.0503 (UTC) FILETIME=[95DC1870:01C8A4BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> --- Original Message --- (akpm wrote:)
>>> On Tue, 22 Apr 2008 08:25:19 -0700 Randy Dunlap
<randy.dunlap@oracle.com> wrote:
>>>
>>> kernel-doc output doesn't depend on build $ARCH.
>> Ah, interesting.  I made an ass of u and me.
>>
>> In that case documentng them in x86 .c and leaving all other definitions
>> and declarations uncommented sounds the way to go?  
>
> Yes, that would be fine and traditional (historical).
>
> ~Randy
>

So is the summary here that we cannot just document the actual
interface API in the incude/linux/kgdb.h?

The problem I had here was pretty simple in that not all of the
functions in the API are used by all the archs.  It seemed pretty
reasonable at the time to just document everything in the .h file
because it was more for the folks who wanted to add kgdb support to an
arch and of little to no use to end users of kgdb.

The mainline only has a small chunk of the docs right now because not
all of kgdb is merged.  I was just hoping it was real easy to generate
some reasonable looking docs.  The docs for all the kgdb code that
exists (in mainline and not in mainline) can be viewed here as an
example.

http://kernel.org/pub/linux/kernel/people/jwessel/kgdb/

Jason.

