Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbYBNCyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbYBNCyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 21:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYBNCyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 21:54:04 -0500
Received: from mail.tmr.com ([64.65.253.246]:39281 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbYBNCyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 21:54:02 -0500
Message-ID: <47B3AD73.7070107@tmr.com>
Date: Wed, 13 Feb 2008 21:54:43 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <200802060227.14385.rjw@sisk.pl> <47A90F23.80009@zytor.com> <200802060242.15097.rjw@sisk.pl> <47A9129A.7050706@zytor.com>
In-Reply-To: <47A9129A.7050706@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
>>> The asm() for making beeps really need to be moved to a function and 
>>> cleaned up (redone in C using inb()/outb()) if they are to be 
>>> retained at all.
>>
>> Yes, they are.  For some people they're the only tool to debug broken 
>> resume.
> 
> That's fine, but they should get cleaned up.
> 
> /me is tempted to provide a version which can send messages in Morse 
> Code ;)
> 
Thought someone did that a while ago. Alan Cox, maybe.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
