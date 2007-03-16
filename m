Return-Path: <linux-kernel-owner+w=401wt.eu-S2992452AbXCPXOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992452AbXCPXOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992456AbXCPXOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:14:12 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:49172 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992452AbXCPXOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:14:11 -0400
Message-ID: <45FB24AC.6080804@nortel.com>
Date: Fri, 16 Mar 2007 17:13:48 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc4
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070316141121.82ba7cb8.randy.dunlap@oracle.com> <20070316153957.232cf648.randy.dunlap@oracle.com>
In-Reply-To: <20070316153957.232cf648.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2007 23:13:52.0500 (UTC) FILETIME=[C31C4340:01C76820]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:

>>allmodconfig on i386:
>>
>>WARNING: "default_idle" [arch/i386/kernel/apm.ko] undefined!
>>WARNING: "machine_real_restart" [arch/i386/kernel/apm.ko] undefined!
>>make[1]: *** [__modpost] Error 1
>>make: *** [modules] Error 2
> 
> 
> Please ignore.
> 
> I think that this was the result of doing 'make allyesconfig && make all'
> followed by 'make allmodconfig && make all' without doing a 'make clean'
> between them.

This would seem to be a bug in the build system then.  Or are you 
supposed to "make clean" after every config change?

Chris
