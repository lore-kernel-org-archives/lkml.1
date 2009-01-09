Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbZAIVrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbZAIVrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbZAIVrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:47:20 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:28078 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbZAIVrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:47:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dj6niM9JE+p2xy5up+Hp3K/AM/Cdwo5SkrxNkS09FvmfXwRIa827pkGz1hNvh3f31m
         Fxwk/Yg/drg3HcuTaoEvR2FFAM0d+BMycnBHdrBQRJSsCL2zXFPFEXGwDWmprI71DP8i
         CmsGSCj2Fawn6mEHLv3Rcjrndox37MngFE0/0=
Subject: Re: git mv (was Re: [git pull] ACPI & Suspend patches for
 2.6.29-rc0)
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
In-Reply-To: <20090109212757.GA25434@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0901090550590.4091@localhost.localdomain>
	 <alpine.LFD.2.00.0901091200150.6528@localhost.localdomain>
	 <alpine.LFD.2.00.0901091537530.16697@localhost.localdomain>
	 <alpine.LFD.2.00.0901091305160.6528@localhost.localdomain>
	 <20090109212757.GA25434@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 13:47:16 -0800
Message-Id: <1231537636.5726.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 22:27 +0100, Sam Ravnborg wrote:
> What other ways exist so I can see what the heck davem did to
> arch/sparc64/kernel/irq.c then?
> 
> I know he added IRQ stacks - but how did the patch look like?
> I know no other way to find the old history than to do:
> 
>     git log --follow arch/sparc/kernel/irq_64.c
> 
> But this also give me what I want. I'm just curious if there is
> a better way - in the case where you know the old name.

In that specific case you could just do:

gitk -- name1 name2

And that might be closer to what you're looking for.

Harvey



