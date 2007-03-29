Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbXC2MZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbXC2MZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 08:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXC2MZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 08:25:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbXC2MZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 08:25:17 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: tighten kernel image page access rights (re-diff against firstfloor tree)
Date: Thu, 29 Mar 2007 14:22:33 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, patches@x86-64.org
References: <460BC6A7.76E4.0078.0@novell.com>
In-Reply-To: <460BC6A7.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291422.33537.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 14:01, Jan Beulich wrote:
> On x86-64, kernel memory freed after init can be entirely unmapped instead
> of just getting 'poisoned' by overwriting with a debug pattern.
> 
> On i386 and x86-64 (under CONFIG_DEBUG_RODATA), kernel text and bug table
> can also be write-protected.
> 
> (Not sure what the symbol 'stext' is good for; can it be removed?)

I see you remove it already

Added thanks
-Andi
