Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYGPRSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYGPRSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYGPRSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:18:39 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:57521 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYGPRSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ir6kxM6tK82iOMTw0VLvt9gaxevjoy5utyQwrDfU1pAaFf0kaJwy6FlFMYR3pNeUOn
         lXiQyRKIh20NdMx/K72aDqZt5i1nc3H9e45UVtpNsn/gtAnaITVL6g4ehQBtM0QWEo9P
         9Of8H+cG464ak0H2Cxjm7FrYUYAnh4hoRyGuw=
Message-ID: <19f34abd0807161018x279ddd94u5625d69673ae34f3@mail.gmail.com>
Date: Wed, 16 Jul 2008 19:18:37 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [git pull] RCU updates for v2.6.27
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <87abghydaq.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080714152045.GA29159@elte.hu>
	 <alpine.LFD.1.10.0807151037060.3017@woody.linux-foundation.org>
	 <19f34abd0807151314r7462ecc4n8483c7e9fd52769f@mail.gmail.com>
	 <87abghydaq.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 7:00 PM, Andi Kleen <andi@firstfloor.org> wrote:
> "Vegard Nossum" <vegard.nossum@gmail.com> writes:
>>
>> But yeah, I'll continue to improve it and hopefully get it in better
>> shape for next time, especially with regards to SMP support. Maybe we
>> can finally have Andrew's review too, if he's not too busy giving all
>> these talks and whatnot. Some of the things we've actually fixed up
>> since last time include impact on the slab code,
>> CodingStyle/checkpatch issues, and the splitting the huge single file
>> of code into its own directory to make it more manageable. Oh, and I
>> believe 64-bit support is new as well.
>
> Have the network (or likely general) IO false positives be fixed
> yet? That seemed like the largest design misfeature last time I looked.
> I suspect it needs integration into the PCI-DMA API.

They haven't.

Integration into DMA API would be really nice (and a quite logical
thing to do). I will take a look at it... (Unless you beat me to it
with a patch, of course ;-))

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
