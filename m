Return-Path: <linux-kernel-owner+w=401wt.eu-S1759189AbZA3A1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189AbZA3A1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZA3A1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:27:41 -0500
Received: from ozlabs.org ([203.10.76.45]:48270 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbZA3A1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:27:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 4 of 7] x86/paravirt: selectively save/restore regs around pvops calls
Date: Fri, 30 Jan 2009 10:57:27 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>,
       Ravikiran Thirumalai <kiran@scalemp.com>
References: <patchbomb.1233182100@abulafia.goop.org> <200901291917.26601.rusty@rustcorp.com.au> <4981773A.1050403@goop.org>
In-Reply-To: <4981773A.1050403@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301057.28418.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009 20:00:34 Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> > It's kind of messy.  Can we do something clever here with token pasting?
> 
> I tried a few things, but no.  Passing in just RAX, and then pasting 
> CLBR_##reg works, and the assembler accepts %RAX - but - the asm code 
> also #defines RAX <some stack offset>, so the assembler ends up seeing 
> %48.  I considered renaming all the CLBR_ defines to CLBR_rax, but that 
> looks unhappy too.  So I stayed with this.

OK, then Acked-by: Rusty Russell <rusty@rustcorp.com.au> on this one too.

Thanks,
Rusty.
