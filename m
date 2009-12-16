Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbZLPGpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbZLPGpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 01:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZLPGpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 01:45:30 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43934 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbZLPGp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 01:45:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KEI3tbfYbLmGV72KsoSMSvwzENmPaA5h6d4H7VwL25Ek58HkKBFV8nYlgKPaWIx4In
         UgT/lbNL+VzXy+EF+UAGscpIBhy0fWiAClE6IxTrFvyXdDGpI3/2n9ns5PI4CpqGYOq3
         Nlhmm2FVXtfHnJ45fWNhXYRn5OaxiBY3uQ6bo=
MIME-Version: 1.0
In-Reply-To: <4B288131.2050306@in.ibm.com>
References: <4B2224C7.1020908@in.ibm.com>
	 <7b6bb4a50912152225p4f5dde13re83c439407c16eaf@mail.gmail.com>
	 <4B288131.2050306@in.ibm.com>
Date: Wed, 16 Dec 2009 14:45:28 +0800
Message-ID: <7b6bb4a50912152245v61a7f1ebgb41f4857134f3476@mail.gmail.com>
Subject: Re: [Next] CPU Hotplug test failures on powerpc
From: Xiaotian Feng <xtfeng@gmail.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 2:41 PM, Sachin Sant <sachinp@in.ibm.com> wrote:
> Xiaotian Feng wrote:
>>
>> Does this testcase hotplug cpu 0 off?
>>
>
> No, i don't think so. It skips cpu0 during online/offline
> process.

Then how could this happen ? Looks like cpu 0 is offline ....
0:mon> <4>IRQ 17 affinity broken off cpu 0
<4>IRQ 18 affinity broken off cpu 0
<4>IRQ 19 affinity broken off cpu 0
<4>IRQ 264 affinity broken off cpu 0
<4>cpu 0 (hwid 0) Ready to die...
<7>clockevent: decrementer mult[83126e97] shift[32] cpu[0]


>
> thanks
> -Sachin
>
> --
>
> ---------------------------------
> Sachin Sant
> IBM Linux Technology Center
> India Systems and Technology Labs
> Bangalore, India
> ---------------------------------
>
>
