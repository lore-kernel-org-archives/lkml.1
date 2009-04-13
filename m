Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbZDMSre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbZDMSre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZDMSr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:47:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbZDMSrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:47:25 -0400
Date: Mon, 13 Apr 2009 11:39:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
In-Reply-To: <20090413073925.GB7085@x200.localdomain>
Message-ID: <alpine.LFD.2.00.0904131137520.26713@localhost.localdomain>
References: <20090410023207.GA27788@x200.localdomain> <alpine.LFD.2.00.0904100758410.4583@localhost.localdomain> <20090413073925.GB7085@x200.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Apr 2009, Alexey Dobriyan wrote:
> 
> Well, in OpenVZ everything is in kernel/cpt/ and prefixed with "cpt_"
> and "rst_".

So?

We're not merging OpenVZ code _either_.

> And I think "cr_" is super nice prefix: it's short, it's C-like,
> it reminds about restart part

It does no such thing. THAT'S THE POINT. "cr" means _nothing_ to anybody 
else than some CR-specific people, and those people don't even need it!

Look around you. We try to use nicer names. We spell out "cpufreq", we 
don't call it "cf".

		Linus
