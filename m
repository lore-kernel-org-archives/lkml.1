Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbYHSLIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbYHSLIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYHSLI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:08:28 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:37743 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751602AbYHSLI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:08:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NZXnQCyRVxyOeGTbRnQGVjP5rILvfNrnTfjAq3eV49+R1UttS9XBKy43MGNOgmUhLRQxo6pzhg+Mj35ZRhvbzK60G6Oc+Gb8OyV5/vRYw6HC9b+pvBMiPavJ8FYYN1CKmiwYSdm0tKqUWFmF0LtCcOaNnWBKsy5JbmquBw52bIA=  ;
X-YMail-OSG: fd6mJecVM1lJLM3Z0YEFRCfNpebv4_ueiDHbTGKsbVFqJMSy8vscLE9tnto1ubCWvEGgm07k5yEEjYoCKHmDfP3Vw_1QvSths.QHm9xqrO40BTuoPCW2XoVtIGjMOdqwtMh0X1JG4dw.y6TLkYL30WCB
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes to use function calls [POST 2]
Date: Tue, 19 Aug 2008 21:08:13 +1000
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <patchbomb.1219083817@localhost> <200808191956.59898.nickpiggin@yahoo.com.au> <20080819102045.GC6722@elte.hu>
In-Reply-To: <20080819102045.GC6722@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192108.13338.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 August 2008 20:20, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > I'm especially sore about mmap because I have a customer with a
> > database that uses a lot of mmap/munmap and those calls have slowed
> > down something like 50%(!!) from 2.6.early to 2.6.late.
>
> oh, agreed that it all needs to speed up - please send testcases ...

I'm not sure if I can send the testcase I have. But this issue is
coming to the top of my list to investigate in mainline, so I'll
check out how we're doing here soon.

