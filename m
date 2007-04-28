Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbXD1ASS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbXD1ASS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 20:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757952AbXD1ASS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 20:18:18 -0400
Received: from gw.goop.org ([64.81.55.164]:39706 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951AbXD1ASR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 20:18:17 -0400
Message-ID: <463292C8.9000307@goop.org>
Date: Fri, 27 Apr 2007 17:18:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177654110.4737.91.camel@nigel.suspend2.net> <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI> <200704272324.43359.rjw@sisk.pl> <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 27 Apr 2007, Rafael J. Wysocki wrote:
>   
>> Why do you think that keeping the user space frozen after 'snapshot' is a bad
>> idea?  I think that solves many of the problems you're discussing.
>>     
>
> It makes it harder to debug (wouldn't it be *nice* to just ssh in, and do
>
> 	gdb -p <snapshotter>
>
> when something goes wrong?)

Yeah, or gdb vmlinux snapshot

Then you could use kexec for resume...

    J
