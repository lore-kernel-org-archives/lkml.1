Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYFJPIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYFJPIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbYFJPHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:07:55 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34456 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753459AbYFJPHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:07:54 -0400
Message-ID: <484E98C4.4040308@sgi.com>
Date: Tue, 10 Jun 2008 08:07:48 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86: Replace xxx_pda() operations with	x86_xx_percpu().
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.711845000@polaris-admin.engr.sgi.com> <20080609130302.GA20943@elte.hu> <484D6A05.7010508@sgi.com> <20080610100907.GL27706@elte.hu>
In-Reply-To: <20080610100907.GL27706@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * Mike Travis <travis@sgi.com> wrote:
>>>
>>>>   * It is now possible to use percpu operations for pda access
>>>>     since the pda is in the percpu area. Drop the pda operations.
>>> FYI, this one didnt build with the attached config.
>>>
>>> 	Ingo
>>>
>> Hi Ingo,
>>
>> Can you send me the output from the build?  It builds fine on my 
>> machine (a few warnings).  The silentoldconfig made these changes to 
>> the .config file.  (I did a git-remote update and reapplied my changes 
>> before building.)
> 
> dont have the log anymore, but i had to revert 3/4 due to the boot 
> crash, could there be a dependency of 4/4 on 3/4?
> 
> the first two patches look fine and survived -tip testing.
> 
> 	Ingo

Thanks Ingo.  I'm narrowing down the reboot problem by pulling config
items out.  I managed to get it to boot but now am trying to understand
how those config options are causing the problem.

Btw, it does not panic/reboot on linux-next with the original config.
Perhaps I should try and bisect to an earlier patch to see what that
reveals?

Thanks,
Mike
