Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYI3QRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYI3QRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYI3QRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:17:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50126 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752446AbYI3QRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:17:08 -0400
Message-ID: <48E25111.7060305@sgi.com>
Date: Tue, 30 Sep 2008 09:17:21 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/31] cpumask: Provide new cpumask API
References: <20080929180250.111209000@polaris-admin.engr.sgi.com> <20080929180250.825653000@polaris-admin.engr.sgi.com> <20080930091140.GB27452@elte.hu> <48E248CB.5080305@sgi.com>
In-Reply-To: <48E248CB.5080305@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Ingo Molnar wrote:
...
> 
>> In what way will Rusty's changes differ? Since you incorporate some of 
>> Rusty's changes already, could you please iterate towards a single 
>> patchset which we could then start testing?
> 
> Our timezones are not very conducive to a lot of email exchanges (and he's moving.)
>>From what I've seen I believe he's leaning towards using struct cpumask * and
> less trickery than I have.

Oh yeah, I forgot the other major point of Rusty's approach.  He wants the
patchset to be completely bisectable.  That's far from true in my version.  

Thanks,
Mike
