Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYJJDoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYJJDoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 23:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYJJDn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 23:43:56 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:31357 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751457AbYJJDnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 23:43:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XmC4qwysG9YWxunXGM3Qd+aInvkF3HE7uXfAP2DQlPGqI2ay2OPw0OUx9qKZe+qsJGXO9TOPUHjpAh1Y3SObX3a0infc1Z9VWB/grkGWSs4RftVMFPtP9R8V/xdJLMUsilVetbqyFmhJOH+PUeeNnbynKRn0w357ZdxTysZ9HHU=  ;
X-YMail-OSG: fcRL.CsVM1lqpRUc6qAAZtCNCeN6XZzfwwLiHN2UBNp8sobjxCDntr5MFKmmlrjyJcKpW_Z2aeSFHkLjQ9GbhWdopD65ZL9qj7VvAS7N7LdN4Q3Caqoj1vH0IWW2dA9Hj2fOlHfDatFWJu1aZaIPoWNegrYXCZYHj2qrBG23
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #6, misc
Date: Fri, 10 Oct 2008 14:43:47 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20081010000817.GA9266@elte.hu>
In-Reply-To: <20081010000817.GA9266@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810101443.48237.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2008 11:08, Ingo Molnar wrote:

> out-of-topic modifications in x86-v28-for-linus-phase6:
> -------------------------------------------------------
> include/linux/kernel.h             # d974ae3: generic, memparse(): constify
> arg include/linux/mm.h                 # f7d0b92: mm: define
> USE_SPLIT_PTLOCKS rath # 59ea746: MM: virtual address debug
> include/linux/mm_types.h           # f7d0b92: mm: define USE_SPLIT_PTLOCKS
> rath include/linux/mmdebug.h            # 7aa413d: x86, MM: virtual address
> debug, c # 59ea746: MM: virtual address debug lib/cmdline.c                
>      # d974ae3: generic, memparse(): constify arg mm/vmalloc.c             
>          # 7aa413d: x86, MM: virtual address debug, c # 59ea746: MM:
> virtual address debug


How come these kinds of things go into the x86 tree? Can't they
be sent to other maintainer first (probably Andrew, in the case
of random -mm stuff).

OK, it's pretty trivial stuff, but just on principle I can't see
an advantage, and only disadvantages to doing this (and also I
see the vmalloc change clashed with the vmalloc rewrite in -mm).
