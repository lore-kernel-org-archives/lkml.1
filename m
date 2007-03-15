Return-Path: <linux-kernel-owner+w=401wt.eu-S933721AbXCOUPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbXCOUPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933749AbXCOUPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:15:21 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:57764 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933721AbXCOUPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:15:19 -0400
Date: Thu, 15 Mar 2007 21:02:43 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0703152102210.1199@yvahk01.tjqt.qr>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
 <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 15 2007 08:59, Linus Torvalds wrote:
>On Thu, 15 Mar 2007, Martin Bligh wrote:
>> 
>> Can't we move the shared files into a new shared arch/ subdirectory
>> (ia32_64 or whatever), and have them included from both places?
>
>That's *exactly* what the patches do (except it's called "arch/x86", which 
>is clearly the best option - please don't use "ia" _anywhere_ except for 
>"ia64", since that's the only architecture that is really "intel 
>architecture").

IA32 = Intel/AMD 32 :)


Jan
-- 
