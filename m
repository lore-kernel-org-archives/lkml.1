Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbYGJR6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbYGJR6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbYGJR6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:58:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47962 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbYGJR6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:58:12 -0400
Message-ID: <48764C21.4020601@zytor.com>
Date: Thu, 10 Jul 2008 13:51:29 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org>	<m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com>	<487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org>	<48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org>	<48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org> <m1prpl4pmh.fsf@frodo.ebiederm.org>
In-Reply-To: <m1prpl4pmh.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Christoph Lameter <cl@linux-foundation.org> writes:
> 
>> H. Peter Anvin wrote:
>>
>>> but there is a distinct lack of wiggle room, which can be resolved
>>> either by using negative offsets, or by moving the kernel text area up a
>>> bit from -2 GB.
>> Lets say we reserve 256MB of cpu alloc space per processor.
> 
> First off right now reserving more than about 64KB is ridiculous.  We rightly
> don't have that many per cpu variables.

Almost half a megabyte in current allyesconfig, and that is not 
including dynamic allocations at all.

	-hpa
