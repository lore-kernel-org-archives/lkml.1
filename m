Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab0CBSkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:40:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830Ab0CBSkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:40:36 -0500
Date: Tue, 2 Mar 2010 10:39:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@linux.kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sachin Sant <sachinp@in.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Alok Kataria <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       =?ISO-8859-15?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [GIT PULL] x86/mm fixes
In-Reply-To: <201003020010.o220Ax3Z025848@hera.kernel.org>
Message-ID: <alpine.LFD.2.00.1003021038410.3616@localhost.localdomain>
References: <201003020010.o220Ax3Z025848@hera.kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Mar 2010, H. Peter Anvin wrote:
> +		pfn = (res.start + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +		end_pfn = (res.end + 1) >> PAGE_SHIFT;
> +		if (end_pfn > pfn)
> +		    ret = (*func)(pfn, end_pfn - pfn, arg);
>  		if (ret)
>  			break;
>  		res.start = res.end + 1;

What kind of messed-up indentation is that? We don't use 4-char indents.

		Linus
