Return-Path: <linux-kernel-owner+w=401wt.eu-S966052AbXHaVWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966052AbXHaVWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760905AbXHaVV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:21:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760865AbXHaVV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:21:57 -0400
Message-ID: <46D8864F.4020904@redhat.com>
Date: Fri, 31 Aug 2007 17:21:19 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, jakub@redhat.com,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <23252.1188396273@turing-police.cc.vt.edu> <3909.1188409058@turing-police.cc.vt.edu>            <20070829161545.9fde1a5c.akpm@linux-foundation.org> <25082.1188482914@turing-police.cc.vt.edu>
In-Reply-To: <25082.1188482914@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2007 10:08 AM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 29 Aug 2007 16:15:45 PDT, Andrew Morton said:
> 
>> So it's an interaction between the x86_64 vdso patches in Andi's tree and 
>> newer glibc, and we don't know which one is getting it wrong yet?
>>
>> If I ever get another -mm out the door (have been without electricity for
>> several days) I'll drop the vdso changes until this is sorted out.
> 
> Don't bother, I tested this last night against a vanilla 2.6.23-rc3 kernel
> and it had the same issue as well.  So Andi's vdso patches in his tree and/or
> the -mm kernel aren't to blame - it's in mainline as well.  And it's been
> in for a while - I also hit it with a 2.6.22-rc6-mm1 kernel.
> 

We also have:

  http://lkml.org/lkml/2007/7/29/376

(Time repeatedly jumps backwards ~4400 seconds.)
