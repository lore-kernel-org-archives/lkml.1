Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbZBJS16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbZBJS16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 13:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZBJS1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 13:27:48 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35734 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZBJS1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 13:27:48 -0500
Message-ID: <4991C71E.9060509@in.ibm.com>
Date: Tue, 10 Feb 2009 23:57:42 +0530
From: Chandru <chandru@in.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       chandru@linux.vnet.ibm.com, paulus@samba.org, akpm@linux-foundation.org,
       Johannes Weiner <hannes@cmpxchg.org>,
       "Jon M. Tollefson [imap]" <kniht@us.ibm.com>
Subject: Re: + powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch
 added to -mm tree
References: <200812250806.mBP86LPQ018399@imap1.linux-foundation.org> <20090208204725.GA5514@cmpxchg.org>  <1234139464.31963.79.camel@pasglop> <1234288310.30155.27.camel@nimitz>
In-Reply-To: <1234288310.30155.27.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Mon, 2009-02-09 at 11:31 +1100, Benjamin Herrenschmidt wrote:
>   
>> Dave, you've had your hands in that code more than I did lately, do
>> that
>> look ok to you ?
>>     
>
> I still think that patch is bogus.  I don't know how it is still around.
> I described the problem pretty completely here:
>
> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4a6186696e7f15b3ea4dafcdb64ee0703e0e4487
>
> Chandru effectively reverted my bugfix from that patch in this one.
>
>   
>> (BTW. On another note, do you still have pending bug fixes that didn't
>> got in .29 ?)
>>     
>
> No, I don't think so.  There were some distro fixes but I couldn't
> reproduce the bugs on mainline.
>
> -- Dave
>
>   
Dave,

If I remember,  the first mail that I sent on this subject said
2.6.28-rc9 panics. Unless something has changed in the way
lmb's are added or are reserved, this should be also
reproducible with the mainline kernel on the machines that
had exhibited this problem earlier. I will verify your patch
on these machines again and let you know the results.

Thanks,
Chandru
