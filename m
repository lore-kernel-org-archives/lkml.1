Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYK0LAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYK0LAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 06:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbYK0LAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 06:00:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34996 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbYK0LAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 06:00:12 -0500
Message-ID: <492E7D91.10407@redhat.com>
Date: Thu, 27 Nov 2008 12:59:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, lguest@ozlabs.org,
       jeremy@xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64,	i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <1226243805.27361.1283784629@webmail.messagingengine.com> <49178E89.2000307@zytor.com> <492DC13F.8020009@redhat.com> <492DE3EF.8060507@zytor.com> <492E72D7.9060201@redhat.com> <20081127105635.GG6703@one.firstfloor.org>
In-Reply-To: <20081127105635.GG6703@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Nice.  Can actually go to zero, by pointing the IDT at (unmapped_area + 
>> vector), and deducing the vector in the page fault handler from cr2.
>>     
>
> That would be still one byte, otherwise you wouldn't get a unique index.
>   

One virtual byte; zero physical bytes.  unmapped_area above need not be 
mapped.

-- 
error compiling committee.c: too many arguments to function

