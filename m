Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbXH1ScB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbXH1ScB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXH1Sby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:31:54 -0400
Received: from ozlabs.org ([203.10.76.45]:58163 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbXH1Sby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:31:54 -0400
Subject: Re: [PATCH 3/3] KVM paravirt-ops implementation
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
In-Reply-To: <11882278093751-git-send-email-aliguori@us.ibm.com>
References: <11882278064002-git-send-email-aliguori@us.ibm.com>
	 <1188227808405-git-send-email-aliguori@us.ibm.com>
	 <11882278082826-git-send-email-aliguori@us.ibm.com>
	 <11882278093751-git-send-email-aliguori@us.ibm.com>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 04:31:30 +1000
Message-Id: <1188325890.5531.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 10:16 -0500, Anthony Liguori wrote:
> @@ -569,6 +570,7 @@ asmlinkage void __init start_kernel(void)
>  	}
>  	sort_main_extable();
>  	trap_init();
> +	kvm_guest_init();
>  	rcu_init();
>  	init_IRQ();
>  	pidhash_init();

Hi Anthony,

	This placement seems arbitrary.  Why not earlier from setup_arch, or as
a normal initcall?

Rusty.


