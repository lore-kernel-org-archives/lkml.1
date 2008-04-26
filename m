Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbYDZWz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbYDZWz4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 18:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbYDZWzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 18:55:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54715 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbYDZWzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 18:55:45 -0400
Message-ID: <4813B1EF.5090806@zytor.com>
Date: Sat, 26 Apr 2008 15:51:27 -0700
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
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl> <517f3f820804140357k62b3bff4p555ba6a5b9438c35@mail.gmail.com> <Pine.GSO.4.56.0804141349060.17644@keg.few.vu.nl> <alpine.DEB.1.10.0804261546140.6108@twinlark.arctic.org>
In-Reply-To: <alpine.DEB.1.10.0804261546140.6108@twinlark.arctic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet wrote:
> 
> i might be too late... but shouldn't these #defines be PR_SET_RDTSC and 
> PR_GET_RDTSC or something like that?
> 
> to me calling them PR_SET_TSC/PR_GET_TSC just seem like alternative ways 
> to change/get the TSC (and could even reduce to portable TSC 
> implementations... since such registers do exist on other architectures).
> 

I would argue no, the flag is "is the TSC available".  RDTSC is an 
x86-specific name and would map poorly onto other architectures.

	-hpa
