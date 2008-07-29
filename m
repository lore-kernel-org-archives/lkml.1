Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYG2KSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYG2KSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYG2KR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:17:57 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:35774 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754023AbYG2KR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:17:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iIhjiJsfJkqWKZJ0yw0UaESq3IRdi5Uf4W8UUgGxzMajg9g32hAI4G1RUQcekU7bNVvx9p8/qqkIYoCbC9CXXdX0bs+tNScPYd/WGU426C2yePv5M75v97TOS4KOFuMpzxiW5zl4FIWfhcfeHT8PyOjOX0id/NcOhsJVo/DFeMc=  ;
X-YMail-OSG: 91sLKwwVM1mznRdghdHjGXdrktWtFOcFdRP1PvgoBx7AJYtEdLWiDPuPUqOule_m1TtfEUuHwVODK2dKYZaMhcuayK.yTBm98k.81TFVjB2B8obIRhTkh1DRrDd_IswI_mM-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: x86: Is there still value in having a special tlb flush IPI vector?
Date: Tue, 29 Jul 2008 20:17:41 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <488E534F.2030204@goop.org> <200807292000.30690.nickpiggin@yahoo.com.au> <1217325853.7563.5.camel@twins>
In-Reply-To: <1217325853.7563.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807292017.42005.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 20:04, Peter Zijlstra wrote:
> On Tue, 2008-07-29 at 20:00 +1000, Nick Piggin wrote:
> > On Tuesday 29 July 2008 19:54, Peter Zijlstra wrote:
> > > On Tue, 2008-07-29 at 14:30 +1000, Nick Piggin wrote:
> > > > Not to mention the minor problem that it still deadlocks when called
> > > > with interrupts disabled ;)
> > >
> > > __smp_call_function_single has potential though..
> >
> > For reschedule interrupt? I don't really agree.
>
> Not specifically, for not deadlocking from irq-off, more so.

Oh, well yes it already does work from irq-off, so it has already
realised its potential :)

Not sure exactly what kinds of users it is going to attract, but
it should be interesting to see!
