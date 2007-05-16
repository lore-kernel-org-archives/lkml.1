Return-Path: <linux-kernel-owner+w=401wt.eu-S1761052AbXEPQIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761052AbXEPQIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbXEPQIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:08:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689AbXEPQIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:08:10 -0400
Message-ID: <464B2C0B.20500@redhat.com>
Date: Wed, 16 May 2007 12:06:35 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Greg KH <greg@kroah.com>
Subject: Re: Oops and Panics in 2.6.21.1, 2.6.20.6 and 2.6.19.2
References: <464A4F56.6080108@tequila.co.jp>	<20070515185350.2e77bf21.akpm@linux-foundation.org>	<464AE56F.3040101@gmail.com> <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com>
In-Reply-To: <464B2605.9040200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>>>  The safest approach I can think of is making
>>> dentries for attributes unreclaimable but those are made reclaimable for
>>> good reasons.  :-(
>> Yeah, that was the google workaround.  It's OK unless you happen to have
>> thousands of disks on an ia32 box.
> 
> I see.  I thought there was different approach on fixing the problem.
> I'll try to backport the synchronization fix but am afraid it can be too
> risky for -stable.  If it seems too risky, I'll send a patch to disable
> reclamation.
> 

Realistically, how can disabling the reclamation be worse than what's
there now?

