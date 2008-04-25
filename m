Return-Path: <linux-kernel-owner+w=401wt.eu-S1765947AbYDYUeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765947AbYDYUeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761735AbYDYUeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:34:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41537 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759181AbYDYUeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:34:10 -0400
Message-ID: <48123A7A.6090402@zytor.com>
Date: Fri, 25 Apr 2008 13:09:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
References: <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48122ECF.405@zytor.com> <20080425200423.GA25950@Krystal>
In-Reply-To: <20080425200423.GA25950@Krystal>
Content-Type: text/plain; charset=windows-1250; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
>> There are only two ways to deal with this - extensive analysis of the 
>> entire flow of control, or telling the compiler exactly what is *actually* 
>> going on.  The latter is the preferred way, obviously.
>>
> 
> Yes, in an ideal world, gcc would help here.
> 

gcc is a free software project, and the gcc maintainers are around and 
can be approached.  A good proposal will go a long way, and patches will 
go even longer.

	-hpa
