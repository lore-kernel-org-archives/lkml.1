Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbXKVDc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbXKVDc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 22:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbXKVDcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 22:32:51 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:54927 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbXKVDcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 22:32:50 -0500
Date: Wed, 21 Nov 2007 20:32:49 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH RFC][try 2] IA64 signal : remove redundant code in setup_sigcontext()
Message-ID: <20071122033249.GM12494@parisc-linux.org>
References: <4744F46B.6050004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4744F46B.6050004@cn.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 11:15:55AM +0800, Shi Weihua wrote:
> This patch removes some redundant code in the function setup_sigcontext().
> 
> The registers ar.ccv,b7,r14,ar.csd,ar.ssd,r2-r3 and r16-r31 are not restored 
> in restore_sigcontext() when (flags & IA64_SC_FLAG_IN_SYSCALL) is true. 
> So we don't need to zero those variables in setup_sigcontext().

Erm, couldn't those registers contain information the process shouldn't
see?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
