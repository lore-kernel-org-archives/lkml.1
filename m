Return-Path: <linux-kernel-owner+w=401wt.eu-S1032440AbXEHWEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032440AbXEHWEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934472AbXEHWEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:04:49 -0400
Received: from gw.goop.org ([64.81.55.164]:49736 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934468AbXEHWEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:04:47 -0400
Message-ID: <4640F3FD.80001@goop.org>
Date: Tue, 08 May 2007 15:04:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC/PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org> <20070508121404.17bd97a6.randy.dunlap@oracle.com> <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com> <4640E98B.4030107@goop.org> <alpine.DEB.0.99.0705081423500.24138@chino.kir.corp.google.com> <4640ED7D.708@goop.org> <alpine.DEB.0.99.0705081453350.25466@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.0.99.0705081453350.25466@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> Now if all such output operands are to specify that the input operands 
> were "modified", 'volatile' is required to ensure the side-effects are 
> preserved or, otherwise, gcc is free optimize the entire asm construct 
> away since it appears to be unused.
>   

Yup.

>> Yeah, they're completely different.  They're not even analogous, really,
>> which was my point.  People confer more meaning to "asm volatile" than
>> it actually has, because of the analogy with volatile variables/types. 
>> They would have been better off with something like "asm static", which
>> isn't much more meaningful, but at least it doesn't mislead the reader
>> into thinking it has anything to do with the other volatile.
>>
>>     
>
> You're point about reordering "asm volatile" constructs differs depending 
> on -mvolatile-asm-stop or -mno-volatile-asm-stop, however.
>   

Erm, that seems to be ia64 specific, and I have no idea what adding a
"stop bit" implies.  Can you set even or odd parity too?

    J
