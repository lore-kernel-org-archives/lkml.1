Return-Path: <linux-kernel-owner+w=401wt.eu-S1763342AbXEUKpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763342AbXEUKpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbXEUKpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:45:09 -0400
Received: from as3.cineca.com ([130.186.84.211]:48338 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbXEUKpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:45:07 -0400
Message-ID: <46517817.1080208@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Andi Kleen <ak@suse.de>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr> <20070520205500.GJ22452@vanheusden.com> <200705202314.57758.ak@suse.de>
In-Reply-To: <200705202314.57758.ak@suse.de>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Date: Mon, 21 May 2007 12:45:06 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> +	switch(sig) {
>> +	case SIGQUIT: 
>> +	case SIGILL: 
>> +	case SIGTRAP:
>> +	case SIGABRT: 
>> +	case SIGBUS: 
>> +	case SIGFPE:
>> +	case SIGSEGV: 
>> +	case SIGXCPU: 
>> +	case SIGXFSZ:
>> +	case SIGSYS: 
>> +	case SIGSTKFLT:
> 
> Unconditional? That's definitely a very bad idea. If anything only unhandled
> signals should be printed this way because some programs use them internally. 
> But I think your list is far too long anyways.
> 
> -Andi
> 

Maybe you could use somthing similar to unhandled_signal() in
arch/x86_64/mm/fault.c, but I agree that the list seems a bit too long...

-Andrea
