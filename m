Return-Path: <linux-kernel-owner+w=401wt.eu-S965804AbXDGLzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965804AbXDGLzH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 07:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965795AbXDGLzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 07:55:07 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:51502 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965804AbXDGLzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 07:55:05 -0400
Message-ID: <46178676.3010704@cosmosbay.com>
Date: Sat, 07 Apr 2007 13:54:30 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take4] FUTEX : new PRIVATE futexes
References: <20060808070708.GA3931@localhost.localdomain> <200608090826.28249.dada1@cosmosbay.com> <200608090843.52893.dada1@cosmosbay.com> <200703152010.35614.dada1@cosmosbay.com> <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com> <20070405194942.1414c030.dada1@cosmosbay.com> <20070407104339.6674336b.dada1@cosmosbay.com> <20070407111849.GT355@devserv.devel.redhat.com>
In-Reply-To: <20070407111849.GT355@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 07 Apr 2007 13:54:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Jelinek a écrit :
> On Sat, Apr 07, 2007 at 10:43:39AM +0200, Eric Dumazet wrote:
>> get_futex_key() does a check against sizeof(u32) regardless of futex being 64bits or not.
>> So it is possible a 64bit futex spans two pages of memory...
> 
> That would be a user bug.  32-bit futexes have to be 32-bit aligned, 64-bit
> futexes have to be 64-bit aligned.

I am not sure what you want to say.

User doing sys_futex64(0x......FFC, FUTEX_WAKE_OP, ...) and crashing kernel or 
corrupting data is ok because its a user bug ?


User is allowed to do anything, kernel must check and protect innocents.
