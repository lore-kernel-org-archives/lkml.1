Return-Path: <linux-kernel-owner+w=401wt.eu-S1751068AbXCETzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbXCETzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 14:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbXCETzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 14:55:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbXCETzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 14:55:07 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Len Brown <lenb@kernel.org>
Subject: Re: [patch] disable NMI watchdog by default
Date: Mon, 5 Mar 2007 20:54:45 +0100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070305122011.GA16133@elte.hu> <200703051242.45635.lenb@kernel.org>
In-Reply-To: <200703051242.45635.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703052054.45292.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 18:42, Len Brown wrote:
> On Monday 05 March 2007 07:20, Ingo Molnar wrote:
> > 
> > Linus,
> > 
> > Andrew sent the patch below (which is now months old and has been in -mm 
> > for some time) towards Andi's tree 4 weeks ago, but apparently it fell 
> > into a black hole there - the patch is still not upstream!
> > 
> > This is a must-have for v2.6.21
> 
> I agree.
> There are multiple machines not booting because of nmi_watchdog.
> Some of them are documented here:
> http://bugzilla.kernel.org/show_bug.cgi?id=7839
> 
> We used to think this was the "nolapic" bug,
> but it is actually the "nmi_watchdog=0" bug.

I thought that one was worked around by Ingo's patch to not do nmi watchdog 
during ACPI methods, wasn't it? 

-Andi
