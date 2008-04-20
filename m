Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYDTVwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYDTVwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 17:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYDTVv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 17:51:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58045 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbYDTVv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 17:51:58 -0400
Message-ID: <480BBAF9.1040702@firstfloor.org>
Date: Sun, 20 Apr 2008 23:51:53 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, dhazelton@enter.net,
       bunk@kernel.org, alan@lxorguk.ukuu.org.uk, shawn.bohrer@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: x86: 4kstacks default
References: <200804181737.m3IHbabI010051@hera.kernel.org>	<20080420104444.GI1595@cs181133002.pp.htv.fi>	<87y778aezh.fsf@basil.nowhere.org>	<200804201144.33308.dhazelton@enter.net>	<480B7CB2.3080002@firstfloor.org>	<20080420114845.77bf3fed@laptopd505.fenrus.org> <20080420144512.d28e5bd2.akpm@linux-foundation.org>
In-Reply-To: <20080420144512.d28e5bd2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Sun, 20 Apr 2008 11:48:45 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
>> We don't have effective physical address based reclaim yet for higher order allocs.
> 
> Lumpy reclaim is supposed to be exactly that.

Also if order 1 allocs were a significant problem on i386 we must have
had lots of reports of EAGAIN on fork/clone with !4k stack kernels. I'm
not aware of an significant number of such reports (there were a few
occasionally, but that is probably normal and unavoidable and can
be caused by other things too like simply running out of lowmem)

-Andi

