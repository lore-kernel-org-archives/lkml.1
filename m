Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbYHGXVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbYHGXVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbYHGXVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:21:30 -0400
Received: from gw.goop.org ([64.81.55.164]:60044 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYHGXVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:21:30 -0400
Message-ID: <489B836A.3050209@goop.org>
Date: Thu, 07 Aug 2008 16:21:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: "H. Peter Anvin" <hpa@kernel.org>, Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org> <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Or we could remove the dependency on max_low_pfn and just create a
> liberal linear to physical mapping for lomem which spans all possible
> low memory; then it doesn't matter so much where it is called.
>   

Yes.  You could just call reserve_top_address() at a suitably early 
point to reserve the space.  Its a pvops API call which has been there 
since patch one or two of pvops.

It does exactly what the rest of this thread discusses, rendering it moot.

    J
