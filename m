Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbXKMSS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbXKMSS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXKMSSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:18:48 -0500
Received: from rtr.ca ([76.10.145.34]:1304 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbXKMSSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:18:46 -0500
Message-ID: <4739EA83.5040006@rtr.ca>
Date: Tue, 13 Nov 2007 13:18:43 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <20071113164650.GA28493@elte.hu> <4739E3D0.10201@rtr.ca> <20071113181228.GF4250@stusta.de>
In-Reply-To: <20071113181228.GF4250@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Nov 13, 2007 at 12:50:08PM -0500, Mark Lord wrote:
>> Ingo Molnar wrote:
>>> for example git-bisect was godsent. I remember that years ago bisection of 
>>> a bug was a very laborous task so that it was only used as a final, 
>>> last-ditch approach for really nasty bugs. Today we can autonomouly bisect 
>>> build bugs via a simple shell command around "git-bisect run", without any 
>>> human interaction! This freed up testing resources 
>> ..
>>
>> It's only a godsend for the few people who happen to be kernel developers
> 
> It's also godsend for users who want a regression they observe fixed.
> 
> If you can tell which patch broke it you often turned a very hard to 
> debug problem into a relatively easy fixable problem.
..

Oh yes, definitely.  When that use happens to be a kernel dev + git user,
it saves the *fool who broke it* a hell of a lot of time, because they can
slough it off onto the poor bloke who notices it.

Mind you, no arguing that this is effective when that poor bloke
has a day free to download the git-tree and build/reboot a dozen times.
