Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbZKEGhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbZKEGhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZKEGhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:37:14 -0500
Received: from ozlabs.org ([203.10.76.45]:59031 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbZKEGhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:37:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] BUILD_BUG_ON: make it handle more cases
Date: Thu, 5 Nov 2009 17:07:15 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Hollis Blanchard <hollisb@us.ibm.com>, Jan Beulich <JBeulich@novell.com>,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
       kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
References: <4AC1E15502000078000516B5@vpn.id2.novell.com> <20091105112020.33f02552.sfr@canb.auug.org.au> <200911051658.36265.rusty@rustcorp.com.au>
In-Reply-To: <200911051658.36265.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911051707.15561.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009 04:58:36 pm Rusty Russell wrote:
> I did a 4.3.3 allmodconfig with this patch on 64-bit a few days back and all
> was fine.  Will try 4.4.0 now.

4.4.1 seems OK (Ubuntu).

This is annoying.  But I'll withdraw the patches; if there's another reason
that 4.4.0 is bad, we can ban it and reintroduce this.  I don't think that
breaking this hack is enough to declare 4.4.0 verboten.

Thanks,
Rusty.
