Return-Path: <linux-kernel-owner+w=401wt.eu-S1030237AbXDVLL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbXDVLL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 07:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030369AbXDVLL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 07:11:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:38789 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293AbXDVLL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 07:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VHPnw2BL37cKxTPOZnnmZePW+PcNRwPZRChlXj1xJe+24huhSGsMe80fWpkcO4pYXJwld2hryvo5b/u7/s1rkasW8Xg9yzNdEQCww43UKLRLK8qpteoCigsFL5a6O0IkKCMqnIJ/jDiw7qShWJigFaiR/5RBAQiYHQyq9Jxz1Vc=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Sun, 22 Apr 2007 07:11:21 -0400
User-Agent: KMail/1.9.6
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr
References: <20070420140457.GA14017@elte.hu> <200704211417.03598.gene.heskett@gmail.com> <20070422080708.GI2986@holomorphy.com>
In-Reply-To: <20070422080708.GI2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704220711.22432.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007, William Lee Irwin III wrote:
>On Sat, Apr 21, 2007 at 02:17:02PM -0400, Gene Heskett wrote:
>> CFS-v4 is quite smooth in terms of the users experience but after
>> prolonged observations approaching 24 hours, it appears to choke the cpu
>> hog off a bit even when the system has nothing else to do.  My amanda runs
>> went from 1 to 1.5 hours depending on how much time it took gzip to handle
>> the amount of data tar handed it, up to about 165m & change, or nearly 3
>> hours pretty consistently over 5 runs.
>
>Welcome to infinite history. I'm not surprised, apart from the time
>scale of anomalies being much larger than I anticipated.

[...]

>Pardon my saying so but you appear to be describing anomalous behavior
>in terms of "scheduler warmups."

Well, that was what I saw, it took gzip about 4 or 5 minutes to get to the 
first 90% hit in htop's display, and it first hit the top of the display with 
only 5%.  And the next backup run took about 2h:21m, so we're back in the 
ballpark.  I'd reset amanda's schedule for a faster dumpcycle too, along with 
giving the old girl a new drive, all about the time we started playing with 
this, so the times I'm recording now may well be nominal.  I suppose I should 
boot a plain 2.6.21-rc7 and make a run & time that, but I don't enjoy 
masochism THAT much. :)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I've enjoyed just about as much of this as I can stand.
