Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842Ab0AFKWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0AFKWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 05:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816Ab0AFKWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 05:22:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab0AFKWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 05:22:07 -0500
Date: Wed, 6 Jan 2010 12:21:29 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jun Koi <junkoi2004@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 00/12] KVM: Add host swap event notifications for PV
 guest
Message-ID: <20100106102129.GG4905@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com>
 <fdaac4d51001050705s3f46dd0fi948a3b3ea803fa51@mail.gmail.com>
 <4B43631A.2030101@redhat.com>
 <fdaac4d51001060217h16ffb331mcc0db195630f4de4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdaac4d51001060217h16ffb331mcc0db195630f4de4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 07:17:30PM +0900, Jun Koi wrote:
> On Wed, Jan 6, 2010 at 1:04 AM, Avi Kivity <avi@redhat.com> wrote:
> > On 01/05/2010 05:05 PM, Jun Koi wrote:
> >>
> >> Is it true that to make this work, we will need a (PV) kernel driver
> >> for each guest OS (Windows, Linux, ...)?
> >>
> >>
> >
> > It's partially usable even without guest modifications; while servicing a
> > host page fault we can still deliver interrupts to the guest (which might
> > cause a context switch and thus further progress to be made).
> 
> Lets say, in the case the guest has no PV driver. When we find that a
> guest page is swapped out, we can send a pagefault
> to the guest to trick it to load that page in. And we dont need the
> driver at all.
> 
That's not the guest who should load the page. From guest's point of view the
page is in memory.

> Is that a reasonable solution?
> 
> Thanks,
> J

--
			Gleb.
