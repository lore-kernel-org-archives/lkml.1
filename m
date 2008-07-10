Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYGJVgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYGJVgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYGJVge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:36:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYGJVgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:36:32 -0400
Message-ID: <48767F4F.1010209@zytor.com>
Date: Thu, 10 Jul 2008 17:29:51 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org> <m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com> <487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org> <48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org> <48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org> <487639ED.7000502@zytor.com> <48763CA6.9030802@linux-foundation.org> <487647EF.5010609@goop.org> <48764A01.1070402@linux-foundation.org> <48764C7C.5010309@goop.org> <48767692.4080504@linux-foundation.org> <487677F0.4000404@goop.org> <4876799B.7010204@linux-foundation.org>
In-Reply-To: <4876799B.7010204@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Jeremy Fitzhardinge wrote:
> 
>> Percpu on i386 hasn't been a point of discussion.  It works fine, and
>> has been working fine for a long time.  The same mechanism would work
>> fine on x86-64.  Its only "issue" is that it doesn't support the broken
>> gcc abi for stack-protector.
> 
> Well that is one thing and then the scaling issues, and the support of the new cpu allocator, new arch independent cpu operations etc.
> 
>> The problem is all zero-based percpu on x86-64.
> 
> The zero based stuff will enable a lot of things. Please have a look at the cpu_alloc patchsets.
> 

No argument this work is worthwhile.  The main issues on the table is 
the particular choice of offsets, and the handling of the virtual space 
-- I believe 2 MB mappings are too large, except perhaps as an option.

	-hpa

