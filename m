Return-Path: <linux-kernel-owner+w=401wt.eu-S1161782AbXDXOgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161782AbXDXOgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 10:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161780AbXDXOgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 10:36:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:60340 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161782AbXDXOgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 10:36:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=naYVCshF4vk8BM/rZYYfNQPGI8BK62t4g0eINOVA7KcKh+MBka6vCHRzupwaw2Az8S943qAxfCDkun+NTwv9fh6wUHKLR7xuQ7Ws7X33aaczQw/wlh1zrHYJdd46jIZ1ROFo+jnHdsJmy3BE267+9pFFiguyBr6sS8ux+/pxD1Y=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Tue, 24 Apr 2007 10:36:15 -0400
User-Agent: KMail/1.9.6
Cc: Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr
References: <200704220959.34978.kernel@kolivas.org> <200704240312.25015.gene.heskett@gmail.com> <20070424071423.GB25322@elte.hu>
In-Reply-To: <20070424071423.GB25322@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704241036.16145.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> > (Btw., to protect against such mishaps in the future i have changed
>> > the SysRq-N [SysRq-Nice] implementation in my tree to not only
>> > change real-time tasks to SCHED_OTHER, but to also renice negative
>> > nice levels back to 0 - this will show up in -v6. That way you'd
>> > only have had to hit SysRq-N to get the system out of the wedge.)
>>
>> That sounds handy, particularly with idiots like me at the wheel...
>
>by that standard i guess we tinkerers are all idiots ;)
>
>	Ingo

Eiyyyup!

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Man's horizons are bounded by his vision.
