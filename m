Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYEJLER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYEJLER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 07:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYEJLEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 07:04:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:52981 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYEJLEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 07:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=u8ib4pV76L3GsqGfxvv0RIAIX9Kel2mi6j8Fs6CmDPw1Wm8Rv7mQw0DG9y3afCCYSvBAH3roINXOqfhPRsDLzDvAfrX0Zyz5tRqw6DGrjdsitSeMFjDCL8C9Rp/Oxi9gA4mk0PQUk3KeQd6Oe1XrQ0AeuMhufzOrXfK1mbuH0i0=
Message-ID: <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com>
Date: Sat, 10 May 2008 13:04:03 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Josh Aune" <luken@omner.org>,
       "Pekka Paalanen" <pq@iki.fi>
In-Reply-To: <482565A5.8010503@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F630AE.7050801@gmail.com>
	 <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com>
	 <482565A5.8010503@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 11:06 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Bart Van Assche wrote:
>>
>> It's a bit late but I finally found out about your announcement of
>> kmemcheck version 7. Are you familiar with the patch that adds support
>> to Valgrind for User Mode Linux ? I'm not sure what the best approach
>> is -- letting the kernel do its own checking like kmemcheck or extend
>> Valgrind such that it supports UML. Anyway, the techniques applied in
>> Valgrind may be useful for kmemcheck too, such as the algorithms used
>> in Valgrind to compress the memory state information.
>
> It's better to do it with the native kernel so you can "valgrind" all the
> interesting driver code.

That's right. This is the paper I was referring to that details how to
minimize the memory consumption when tracking state information:
http://www.valgrind.org/docs/shadow-memory2007.pdf

Bart.
