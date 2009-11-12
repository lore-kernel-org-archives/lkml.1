Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZKLPQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZKLPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZKLPQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:16:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbZKLPQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:16:57 -0500
Message-ID: <4AFC26AF.8050609@zytor.com>
Date: Thu, 12 Nov 2009 07:15:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
References: <20091110034831.GB26809@elte.hu> <20091110041452.GA25575@suse.de> <1257863388.4184.220.camel@mulgrave.site> <20091110193747.GB12686@suse.de> <1257965424.11985.9.camel@mulgrave.site> <alpine.LFD.2.01.0911111153390.31845@localhost.localdomain> <1257970010.11985.17.camel@mulgrave.site> <alpine.LFD.2.01.0911111211270.31845@localhost.localdomain> <4AFB301C.3050800@zytor.com> <alpine.LFD.2.01.0911111350290.31845@localhost.localdomain> <20091112074531.GA16434@elte.hu>
In-Reply-To: <20091112074531.GA16434@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 11:45 PM, Ingo Molnar wrote:
> 
> That's already possible via the git-commits-head@vger.kernel.org email 
> list. Anyone can subscribe to it and can procmail process it. It is also 
> more secure (and less intrusive to the tree owner) than any post-push 
> hook script running under the pusher's UID. Polling via cron is really 
> not required i think.
> 

There are a couple of disadvantages with this -- a hera -> vger -> hera
bounce, in particular (those two machines are nowhere close to each
other, and there can be huge latecy.)  For real-time robots running on
hera, a lower-latency mechanism would be useful.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

