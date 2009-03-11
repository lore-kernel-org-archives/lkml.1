Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZCKMTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZCKMTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZCKMTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:19:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51604 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbZCKMTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:19:24 -0400
Date: Wed, 11 Mar 2009 13:38:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: suggest running a 64bit kernel on LM capable machines with plenty memory.
Message-ID: <20090311123845.GF11935@one.firstfloor.org>
References: <49B254C6.8010507@pardus.org.tr> <20090307193026.GA2165@x200.localdomain> <49B2CE44.4060305@pardus.org.tr> <87r617ojfi.fsf@firstfloor.org> <1236606168.8389.512.camel@laptop> <20090309191504.GB11935@one.firstfloor.org> <1236677828.25234.9.camel@laptop> <20090310062134.704d2c7e@infradead.org> <1236772885.8192.241.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236772885.8192.241.camel@laptop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Esp on x86_64 machines with >=4G of memory its insane to run i386-PAE.

Not sure I would apply insane to 4GB, but it definitely applies 
to >= 16GB, likely >= 8GB. Enough known deadlocks in this case.
I would consider >=16GB on 32bit at least a kerneloops worthy condition.

Perhaps the warnings should vary in urgency.  e.g. if it's >= 16GB and 
not 2:2 split we know that the system will have problems and it should
strongly suggest, otherwise weakly.

Or perhaps it should be measured in percentage of mem_map
in lowmem?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
