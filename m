Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYGKPdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYGKPdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYGKPdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:33:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277AbYGKPdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:33:45 -0400
Message-ID: <48777D15.6040107@linux-foundation.org>
Date: Fri, 11 Jul 2008 10:32:37 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mike Travis <travis@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org> <48763732.7020805@sgi.com> <487641D6.5060206@goop.org> <487649B2.3000405@sgi.com> <48764E8A.5010400@zytor.com> <4876766F.4030605@linux-foundation.org> <48767804.8080007@zytor.com> <48767A28.7070900@linux-foundation.org> <48767AF5.7030205@zytor.com>
In-Reply-To: <48767AF5.7030205@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Christoph Lameter wrote:
>> H. Peter Anvin wrote:
>>
>>> And how much is that, especially on *small* systems?
>>
>> i386?
>>
>> i386 uses 4K mappings. There are just a few cpus supported, there is
>> scarcity of ZONE_NORMAL memory so the per cpu areas really cannot get
>> that big. See the cpu_alloc patchsets for i386.
>>
> 
> No, not i386.  x86-64.

x86_64 are small systems? For 64 bit use one would expect 4GB of memory.
