Return-Path: <linux-kernel-owner+w=401wt.eu-S1161520AbXD3APo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161520AbXD3APo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161602AbXD3APn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:15:43 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51404 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161520AbXD3APZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:15:25 -0400
Message-ID: <463535B8.7020101@oracle.com>
Date: Sun, 29 Apr 2007 17:18:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
References: <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org> <20070428030805.GA13331@redhat.com> <20070428161136.GL11166@waste.org> <20070428171101.GC20646@redhat.com> <20070428172154.GA11115@waste.org> <20070429163701.fb994561.randy.dunlap@oracle.com> <20070430000925.GK11115@waste.org>
In-Reply-To: <20070430000925.GK11115@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Sun, Apr 29, 2007 at 04:37:01PM -0700, Randy Dunlap wrote:
>> On Sat, 28 Apr 2007 12:21:54 -0500 Matt Mackall wrote:
>>
>>> On Sat, Apr 28, 2007 at 01:11:01PM -0400, Dave Jones wrote:
>>>> On Sat, Apr 28, 2007 at 11:11:36AM -0500, Matt Mackall wrote:
>>>>  > > I'm all ears for additional regexps, bug reports or other suggestions.
>>>>  > 
>>>>  > Neat.
>>>>  > 
>>>>  > Does it check for:
>>>>  > 
>>>>  > functions marked extern?
>> 	data marked extern?
> 
> It's perfectly reasonable to have a data extern declaration in a header file.

but it's not perfectly acceptable to have

extern unsigned long volatile jiffies;

in a .c file.

The biggest problem I'm seeing ATM is that this script is a bit too
simplistic.  It doesn't know what it's looking at.  We'll have to
address that, I think.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
