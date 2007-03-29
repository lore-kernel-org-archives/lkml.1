Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbXC2NyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbXC2NyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 09:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbXC2NyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 09:54:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbXC2NyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 09:54:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: tighten kernel image page access rights (re-diff against firstfloor tree)
Date: Thu, 29 Mar 2007 15:54:07 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, patches@x86-64.org
References: <460BC6A7.76E4.0078.0@novell.com> <200703291422.33537.ak@suse.de> <460BDFF9.76E4.0078.0@novell.com>
In-Reply-To: <460BDFF9.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291554.08017.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 15:49, Jan Beulich wrote:
> >>> Andi Kleen <ak@suse.de> 29.03.07 14:22 >>>
> >On Thursday 29 March 2007 14:01, Jan Beulich wrote:
> >> On x86-64, kernel memory freed after init can be entirely unmapped instead
> >> of just getting 'poisoned' by overwriting with a debug pattern.
> >> 
> >> On i386 and x86-64 (under CONFIG_DEBUG_RODATA), kernel text and bug table
> >> can also be write-protected.
> >> 
> >> (Not sure what the symbol 'stext' is good for; can it be removed?)
> >
> >I see you remove it already
> 
> I don't think I do - I just move _stext (on x86-64), but leave stext alone.

Ok i removed it now

-Andi

