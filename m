Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbYGJVFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbYGJVFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYGJVFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:05:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59809 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbYGJVFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:05:42 -0400
Message-ID: <48767804.8080007@zytor.com>
Date: Thu, 10 Jul 2008 16:58:44 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Mike Travis <travis@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org> <48763732.7020805@sgi.com> <487641D6.5060206@goop.org> <487649B2.3000405@sgi.com> <48764E8A.5010400@zytor.com> <4876766F.4030605@linux-foundation.org>
In-Reply-To: <4876766F.4030605@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> H. Peter Anvin wrote:
> 
>> I'm much more concerned about wasting an average of 1 MB of memory per CPU.
> 
> Well all the memory that is now allocated via allocpercpu()s will be allocated from  that 2MB segment. And cpu_alloc packs variables in a dense way. The current slab allocations try to avoid sharing cachelines which wastes lots of memory for every allocation for each and every processor.
> 

And how much is that, especially on *small* systems?

	-hpa
