Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbZKIR0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbZKIR0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbZKIR0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:26:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755097AbZKIR0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:26:46 -0500
Date: Mon, 9 Nov 2009 09:26:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jiri Slaby <jirislaby@gmail.com>
cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
 external to a process (v7)
In-Reply-To: <4AF84E2F.3010305@gmail.com>
Message-ID: <alpine.LFD.2.01.0911090920580.31845@localhost.localdomain>
References: <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org>
 <20091106092600.GC22505@elte.hu> <4AF7D8C2.60807@gmail.com> <20091109090143.GB24020@elte.hu> <4AF83B9A.60702@gmail.com> <20091109164053.GB5160@redhat.com> <4AF84E2F.3010305@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Nov 2009, Jiri Slaby wrote:

> On 11/09/2009 05:40 PM, Oleg Nesterov wrote:
> > Also, I don't understand why wthis code get's both pid and task_struct().
> 
> And what do you suggest? I, with my knowledge and after fast
> investigation, see no other option.

Isn't

	task = find_task_by_vpid(pid);

what you want?

		Linus
