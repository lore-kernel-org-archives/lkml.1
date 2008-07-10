Return-Path: <linux-kernel-owner+w=401wt.eu-S1759826AbYGJRVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826AbYGJRVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbYGJRUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:20:41 -0400
Received: from relay2.sgi.com ([192.48.171.30]:55866 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754840AbYGJRUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:20:40 -0400
Message-ID: <487644E7.6080609@sgi.com>
Date: Thu, 10 Jul 2008 10:20:39 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org> <48763732.7020805@sgi.com> <487637DE.1050706@zytor.com>
In-Reply-To: <487637DE.1050706@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mike Travis wrote:
>> Eric W. Biederman wrote:
>> ...
>>> Another alternative that almost fares better then a segment with
>>> a base of zero is a base of -32K or so.  Only trouble that would get us
>>> manually managing the per cpu area size again.
>>
>> One thing to remember is the eventual goal is implementing the cpu_alloc
>> functions which I think we've agreed has to be "growable".  This means
>> that
>> the addresses will need to be virtual to allow the same offsets for
>> all cpus.
>> The patchset I have uses 2Mb pages.  This "little" twist might figure
>> into the
>> implementation issues that are being discussed.
>>
> 
> No, since the *addresses* can be arbitrary.  The current issue is about
> *offsets.*
> 
>     -hpa

Ok, thanks for clearing that up.  I just didn't want us to drop the ball
trying to make that double play... ;-)

Cheers,
Mike
