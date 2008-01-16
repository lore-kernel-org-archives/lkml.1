Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbYAPVjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbYAPVjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYAPVjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:39:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:37909 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYAPVjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:39:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I2TRBv4+IleLuRiTyjQW8l2qcdT2kPRwwxzDKK4m8BESx1yCoR4G5o9SlwWsGsKVjhx8XJ9U63UqVYrxQtTFnU2fV4ulQAFqKEeNvCFivb3NxCEI9BxRu9h+iQXL2JVU3xq4gSvo8TRj3mtSpq/VI+gp2dT2eYKpGPLD0R2FOP0=
Message-ID: <86802c440801161339h4e3e983co67e05a231666d050@mail.gmail.com>
Date: Wed, 16 Jan 2008 13:39:42 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Balaji Rao" <balajirrao@gmail.com>
Subject: Re: hpet_late_init hang
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200801161404.33519.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440801151932o6aaea248w7d1137eaa2ac3579@mail.gmail.com>
	 <20080116065133.GA26783@elte.hu>
	 <200801161404.33519.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 16, 2008 12:34 AM, Balaji Rao <balajirrao@gmail.com> wrote:
> On Wednesday 16 January 2008 12:21:33 pm Ingo Molnar wrote:
> Hi Ingo,
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > > "
> > > commit e5ed385fa0d6f35406e3e3ed75e5eb9adeb811df
> > > Author: Balaji Rao <balajirrao@gmail.com>
> > > Date:   Tue Jan 15 16:53:29 2008 +0100
> > >
> > >     Assign IRQs to HPET Timers
> > > "
> > > in x86.git
> > >
> > > cause my servers hang
> > > after
> > > Calling initcall 0xffffffff80b9a465: hpet_late_init+0x0/0x100()
..
> Looks like IRQ 31 is assigned to timer 3, even without the patch! I wonder who wrote the number 31. But the manual says
> that it is zero by default.
>
> I think we should check whether the timer has been allocated an IRQ before proceeding to assign one to it.
> Here is a patch that does this.
>
> Yinghai, could you please apply this on top of my patch and check ?
>
> ---
> Index: linux-2.6/arch/x86/kernel/hpet.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/hpet.c
...
>

it works

YH
