Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbXI2M4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbXI2M4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 08:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbXI2M4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 08:56:43 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:31485 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755913AbXI2M4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 08:56:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Absm+ZtuU62lv5Ah+nvgyi65XOjVqni/bDBILbbH6FyVhajnv0FR6/glv94Y6j/0HZAIFBNbLaqWUKI2Z2+ghBqgUlhWRV5Txv9MixEHPfYYvvVV9fV7pxWIQMDOTVOsPhN7kcqkBuicMkvyFVFndYUu0X1dc5gqyXuBdEIvVHY=  ;
X-YMail-OSG: 0I2_y6QVM1mvDwq.ZApUcfQ1HS6POmyCQ2y0mb.pj3sqj02gmcU8PxMNU0mX8RrZDtcsUAasbA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] writeback: remove unnecessary wait in throttle_vm_writeout()
Date: Sat, 29 Sep 2007 06:25:22 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, hirofumi@mail.parknet.co.jp,
       galak@kernel.crashing.org, zaitcev@redhat.com, greg@kroah.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mbligh@google.com
References: <390857819.00313@ustc.edu.cn> <200709281010.28086.nickpiggin@yahoo.com.au> <20070928175756.GA16066@Krystal>
In-Reply-To: <20070928175756.GA16066@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709290625.23043.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2007 03:57, Mathieu Desnoyers wrote:

> Isn't the actual instrumentation present in the VM subsystem consisting
> mostly of event counters ? This kind of profiling provides limited help in
> following specific delays in the kernel. Martin Bligh's paper "Linux
> Kernel Debugging on Google-sized clusters", presented at OLS2007,
> discusses instrumentation that had to be added to the VM subsystem in
> order to find a race condition in the OOM killer by gathering a trace of
> the problematic behavior. Gathering a full trace (timestamps and events)
> seems to be better suited to this kind of timing-related problem.

AFAIK, nobody is nacking patches that add more generally useful
instrumentation to the vm.

You'll obviously always get problems that you need specialised
information to solve. Those kinds of corner cases are probably a
good idea for dynamic instrumentation I guess.
