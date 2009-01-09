Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbZAIVlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbZAIVlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbZAIVlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:41:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbZAIVlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:41:02 -0500
Date: Fri, 9 Jan 2009 13:40:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
Subject: Re: git mv (was Re: [git pull] ACPI & Suspend patches for
 2.6.29-rc0)
In-Reply-To: <20090109212757.GA25434@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0901091339270.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901090550590.4091@localhost.localdomain> <alpine.LFD.2.00.0901091200150.6528@localhost.localdomain> <alpine.LFD.2.00.0901091537530.16697@localhost.localdomain> <alpine.LFD.2.00.0901091305160.6528@localhost.localdomain>
 <20090109212757.GA25434@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Sam Ravnborg wrote:
> 
> What other ways exist so I can see what the heck davem did to
> arch/sparc64/kernel/irq.c then?

Sure, use "git log --follow".

I'm just saying that you can't expect the rest of the git powertools to 
print pretty histories.. In particular, none of the graphical tools will 
give you that nice merge history stuff - because the way "--follow" works, 
we simply don't do that.

		Linus
