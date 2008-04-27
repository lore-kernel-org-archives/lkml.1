Return-Path: <linux-kernel-owner+w=401wt.eu-S1761292AbYD0Al2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292AbYD0Al2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 20:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbYD0AlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 20:41:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbYD0AlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 20:41:20 -0400
Message-ID: <4813CABD.7040603@zytor.com>
Date: Sat, 26 Apr 2008 17:37:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: dean gaudet <dean@arctic.org>
CC: Erik Bosman <ejbosman@cs.vu.nl>, Michael Kerrisk <mtk.manpages@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl> <517f3f820804140357k62b3bff4p555ba6a5b9438c35@mail.gmail.com> <Pine.GSO.4.56.0804141349060.17644@keg.few.vu.nl> <alpine.DEB.1.10.0804261546140.6108@twinlark.arctic.org> <4813B1EF.5090806@zytor.com> <alpine.DEB.1.10.0804261612430.6108@twinlark.arctic.org> <4813BED5.7070000@zytor.com> <alpine.DEB.1.10.0804261725480.6108@twinlark.arctic.org>
In-Reply-To: <alpine.DEB.1.10.0804261725480.6108@twinlark.arctic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet wrote:
>>>
>> PR_SET/PR_GET are the common prefixes, though.
> 
> that's not what's at issue... "PR_SET_TSC" reads "set the TSC" ... it 
> doesn't read "set the ability to use the rdtsc instruction". 
> PR_SET_RDTSC_ENABLE would seem to be more accurate... or even 
> PR_SET_CR4_TSD which is what it really does :)
> 

The whole point I'm making is that any such name would inherently read 
x86-specific.

	-hpa
