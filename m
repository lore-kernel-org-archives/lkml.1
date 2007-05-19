Return-Path: <linux-kernel-owner+w=401wt.eu-S1762999AbXESKQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762999AbXESKQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 06:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbXESKQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 06:16:21 -0400
Received: from as1.cineca.com ([130.186.84.251]:58950 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbXESKQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 06:16:20 -0400
Message-ID: <464ECE6A.4050607@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andi Kleen <ak@suse.de>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
References: <464C81B5.8070101@users.sourceforge.net> <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705180825280.3231@yvahk01.tjqt.qr> <200705181347.14256.ak@suse.de> <Pine.LNX.4.61.0705190946430.9015@yvahk01.tjqt.qr> <464EC4E4.5030401@users.sourceforge.net> <Pine.LNX.4.61.0705191205530.9015@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705191205530.9015@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Sat, 19 May 2007 12:16:18 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On May 19 2007 11:35, Andrea Righi wrote:
>> Jan Engelhardt wrote:
>>> On May 18 2007 13:47, Andi Kleen wrote:
>>>>> I do not see such on i386, so why for x86_64?
>>>> So that you know that one of your programs crashed. That's a feature.
>>> This feature could be handy for i386 too.
>>>
>> What about your /proc/sys/kernel/print-fatal-signals? it must be set to 1 to
>> enable that feature.
> 
> That file does not exist on versions
>   2.6.18 <= version <= 2.6.20
> 

This means that you must apply the print_fatal_signals patch...

-Andrea
