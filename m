Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYFUVWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYFUVWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 17:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYFUVWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 17:22:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:14972 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbYFUVWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 17:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ikyviNfyMXYtwg68GcsFiwfHA1AEB7Gz/ypUG5C9gUoDdv0tMg11zbf21fi7S6epGn
         KGrosYy1UWJ9KNOvCkrIeJ3Vh45K1I6autSXkHWoGs5yC7/t78/7KdyzFI+1JttBjkg6
         Wpmz5GzF6VLSHYrxRjqBA9eQUullMujDhP9AI=
Message-ID: <19f34abd0806211422g6566027et5ea50445b34177fa@mail.gmail.com>
Date: Sat, 21 Jun 2008 23:22:09 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: v2.6.26-rc7: Negative powertop values
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080621141615.51f7100c@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0806211216y4695c532ndb4935082bd8ea1@mail.gmail.com>
	 <20080621141615.51f7100c@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 11:16 PM, Arjan van de Ven
<arjan@linux.intel.com> wrote:
> On Sat, 21 Jun 2008 21:16:37 +0200
> "Vegard Nossum" <vegard.nossum@gmail.com> wrote:
>> I was testing v2.6.26-rc7 by running lmbench and hotplug/-unplugging
>> CPUs and a few other programs at the same time. Powertop was showing a
>> negative number of wakeups/second and average C3 residency was
>> something really insane. Is there anything strange with this schedstat
>> file, or is there another file I should look at that can explain the
>> strange powertop numbers? Or maybe it's just an artifact of powertop
>> and this has nothing to do with the kernel?
>
> powertop doesn't assume you do cpu hotunplug (and the internal state
> goes wacky if you do).
>

Oh right :-) Are there any plans to support this?

> [I assume you know that doing a software unplug you burn more power
> than by leaving the cpu idle]

Well, yeah, this was purely to exercise the kernel a bit, IOW testing.
I guess this can be signed off as a non-kernel issue, then. Thanks for
the quick reply!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
