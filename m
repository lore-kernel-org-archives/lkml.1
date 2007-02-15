Return-Path: <linux-kernel-owner+w=401wt.eu-S1161523AbXBOWVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161523AbXBOWVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161524AbXBOWVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:21:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36900 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161523AbXBOWV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:21:29 -0500
Date: Thu, 15 Feb 2007 14:21:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Corey Minyard <minyard@acm.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/4] ipmi: add new IPMI nmi watchdog handling
Message-Id: <20070215142124.4a6733fc.akpm@linux-foundation.org>
In-Reply-To: <45D480FB.4030503@acm.org>
References: <20070214201257.GD5364@localdomain>
	<20070214195718.e78458cf.akpm@linux-foundation.org>
	<17875.56356.396676.239952@cargo.ozlabs.ibm.com>
	<20070214201632.a7f18794.akpm@linux-foundation.org>
	<45D480FB.4030503@acm.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 09:49:15 -0600
Corey Minyard <minyard@acm.org> wrote:

> So I see the following options besides what's already there:
> 
> 1) add asm/kdebug.h and DIE_NMI_POST to everything that might have an 
> IPMI implementation.
> 2) use CONFIG_X86 to tell if NMI will work, since that's the only thing 
> it will work on at the present.
> 
> I don't have any way to know how different systems have implemented that 
> feature, so I can't actually implement it for the various architectures 
> (plus I don't have any of those boards).  So maybe #2 is the best?

I tend to think that #1 is the best option - it keeps things consistent
and it gives arch/board maintainers a framework in which to add the
support code at their leisure.   But it's something which would be best
worked through with the affected arch maintainers, please.

Which architectures are we talking about here?  ia64 and ppc?
