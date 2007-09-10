Return-Path: <linux-kernel-owner+w=401wt.eu-S965797AbXIJXdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965797AbXIJXdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 19:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbXIJXdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 19:33:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbXIJXde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 19:33:34 -0400
Message-ID: <46E5D44A.5000201@redhat.com>
Date: Mon, 10 Sep 2007 19:33:30 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Prakash Punnoor <prakash@punnoor.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why do so many machines need "noapic"?
References: <46DF3BFF.9000809@redhat.com> <p73veao9gih.fsf@bingen.suse.de> <46E1A7B5.6000104@redhat.com> <200709080717.58271.prakash@punnoor.de> <46E59716.6020404@redhat.com> <20070910194421.GA1819@one.firstfloor.org>
In-Reply-To: <20070910194421.GA1819@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2007 03:44 PM, Andi Kleen wrote:
>> Yes, it has an hpet. And I tried every combination of options I could
>> think of.
> 
>> But, even stranger, x86_64 works (only i386 fails.)
> 
> x86-64 has quite different time code (at least until the dyntick patches
> currently in mm) 
> 
> Obvious thing would be to diff the boot messages and see if anything
> jumps out (e.g. in interrupt routing).  
> 
> Or check with mm and if x86-64 is broken there too then it's likely
> the new time code.

This is Fedora 8 and it already has the highres-timers code in x86_64.
But I was still comparing 2.6.22 on i386 to 2.6.23-rc5-git1 + highres-timers
on x86_64. 2.6.23-rc5 on i386 seems okay too, so whatever is happening it
only occurs on 2.6.22 here.
