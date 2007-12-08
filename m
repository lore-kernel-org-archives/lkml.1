Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbXLHA5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbXLHA5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 19:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbXLHA5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 19:57:37 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:28705 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751949AbXLHA5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 19:57:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fvkLPH5O5YYwc1f3GSpWfpkL0qWUhUlC+w4IMJ6I6PrNNyCOu4iVPuEpkltGP3edho12HU3/S0hWyH37sVv6zwqJC2nPCUj6dMUpSP/1WAaDKUFUjO4LjmIKxam0rAQ6fEGLBBTneOINxThms7aUImudNLE6i6OPJXA4ZsTdz78=  ;
X-YMail-OSG: GJR_LXsVM1m5TD0nNihO7SUz95YNt_vuKEIe9lz3_fzsWb1tLbMSGPz1uqaidycLMlRfgAYVRA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Date: Sat, 8 Dec 2007 11:57:27 +1100
User-Agent: KMail/1.9.5
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
References: <20071207021952.6f0ac922@morte> <200712080348.53117.nickpiggin@yahoo.com.au> <200712081150.50737.nickpiggin@yahoo.com.au>
In-Reply-To: <200712081150.50737.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712081157.27840.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 December 2007 11:50, Nick Piggin wrote:

> I guess your patch is fairly complex but it should work

I should also add that although complex, it should have a
much smaller TSC delta window in which the wrong scaling
factor can get applied to it (I guess it is about as good
as you can possibly get). So I do like it :)
