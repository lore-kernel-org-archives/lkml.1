Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZA3S7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZA3S7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZA3S7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:59:23 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45446 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbZA3S7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:59:23 -0500
Subject: Re: [PATCH] voyager: fix up for moving the generic smp call func
	to pointers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090130185411.GA9984@elte.hu>
References: <1233340524.3248.45.camel@localhost.localdomain>
	 <20090130185411.GA9984@elte.hu>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 18:59:22 +0000
Message-Id: <1233341963.3248.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 19:54 +0100, Ingo Molnar wrote:
> James,
> 
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > commit e7986739a76cde5079da08809d8bbc6878387ae0
> > Author: Mike Travis <travis@sgi.com>
> > Date:   Tue Dec 16 17:33:52 2008 -0800
> > 
> >     x86 smp: modify send_IPI_mask interface to accept cpumask_t pointers
> > 
> > Changed all the IPI ops to take pointers, but didn't update voyager,
> > which is now broken.  Make the changes in voyager as well.
> 
> Note: earlier this week i've rearchitectured the x86 subarchitecture and 
> APIC code - so there's a whole lot more to be done on the Voyager side 
> than just the cpumask conversion.

Not for 2.6.29 there isn't.

> The x86/Voyager subarch is not fully ported yet (i cleaned up its Kconfig 
> impact already) and hence it is disabled for the time being. It ought to 
> be relatively straightforward to port it to the new code - if you are 
> interested in doing that.
> 
> You can find the latest code in tip/master at:
> 
>    http://people.redhat.com/mingo/tip.git/README
> 
> it's tentatively aimed for v2.6.30.

Right, and I'll fix the rest for 2.6.30.  However, this patch is needed
now to get 2.6.29-rc3 to boot.

James


