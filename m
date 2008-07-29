Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYG2KAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYG2KAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbYG2KAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:00:44 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:35630 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754842AbYG2KAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:00:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ctG+nHeH2cPPKycRZ3r7ptsSefwYPVnsIxdrh1aHrqDoXkbDIT4+KBrkeL44nFBMCuv2RQYXDD0GDwOGKkh8TjLF3o4GVxW/X4VzA5rTNX8o2v2AvxHIMOI7D/1jzKm9yCqZs1RR3CJs8pcV8JpkpbvUHA/2d9GLIGX6dAmAn9g=  ;
X-YMail-OSG: Tf4Gv1UVM1nHmlp0ptwqiZkENKJI8dbo1zuEVDDXnsN8hsWH5b09bK_tDjlcb4GvyTFASv1dvPjRJ2dIUs8uqejmT8uYPtCYzEn96k.8fyu3qG_VCiV_PgDmkV3VvFYrv98-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: x86: Is there still value in having a special tlb flush IPI vector?
Date: Tue, 29 Jul 2008 20:00:30 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <488E534F.2030204@goop.org> <200807291430.08220.nickpiggin@yahoo.com.au> <1217325288.7563.2.camel@twins>
In-Reply-To: <1217325288.7563.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807292000.30690.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 19:54, Peter Zijlstra wrote:
> On Tue, 2008-07-29 at 14:30 +1000, Nick Piggin wrote:
> > Not to mention the minor problem that it still deadlocks when called with
> > interrupts disabled ;)
>
> __smp_call_function_single has potential though..

For reschedule interrupt? I don't really agree.
