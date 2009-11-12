Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbZKLPxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbZKLPxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZKLPxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:53:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbZKLPxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:53:23 -0500
Date: Thu, 12 Nov 2009 07:52:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <htejun@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
In-Reply-To: <4AFC2D86.9060406@gmail.com>
Message-ID: <alpine.LFD.2.01.0911120751080.31845@localhost.localdomain>
References: <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu> <4AF9C402.9040800@kernel.org> <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain> <4AFA35CB.5030801@kernel.org>
 <20091111113147.GB7487@elte.hu> <4AFAAC32.4020104@kernel.org> <20091111195751.GA13574@elte.hu> <4AFBDF43.3010703@kernel.org> <20091112103639.GB24684@elte.hu> <4AFBEA4B.4070100@kernel.org> <alpine.LFD.2.01.0911120714260.31845@localhost.localdomain>
 <4AFC2A17.9030706@kernel.org> <4AFC2D86.9060406@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Nov 2009, Tejun Heo wrote:

> 11/13/2009 12:30 AM, Tejun Heo wrote:
> >> 'checkpatch' is the major reason for them, but I think we've fixed 
> >> checkpath long ago to not warn about long lines if they are due to a long 
> >> string.
> 
> It still warns...  :-(
> 
>  WARNING: line over 80 characters
>  #11: FILE: mm/percpu.c:1100:
>  +                               err = "failed to extend area map of reserved chunk";

Ok, just ignore it. The 80-column warning has always been sh*t anyway.

It may be that the "long line" warning is suppressed only for actual 
'printk()' cases, but it may also be that it looks at the intendation and 
only suppresses it for low levels of indents. I'm allergic to perl, so I'm 
not even going to look to try to find out the details.

		Linus
