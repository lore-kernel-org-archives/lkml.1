Return-Path: <linux-kernel-owner+w=401wt.eu-S935637AbXGRRlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935637AbXGRRlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbXGRRlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:41:24 -0400
Received: from [198.99.130.12] ([198.99.130.12]:44109 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbXGRRlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:41:23 -0400
Date: Wed, 18 Jul 2007 13:41:04 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@qumranet.com>, KVM devel <kvm-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH 3/3] KVM - add hypercall nr to kvm_run
Message-ID: <20070718174104.GA8655@c2.user-mode-linux.org>
References: <20070716192447.GA16253@c2.user-mode-linux.org> <469C7C8D.1020600@qumranet.com> <469CCF17.3020709@codemonkey.ws> <20070717160710.GC7965@c2.user-mode-linux.org> <469E3FA2.7060408@codemonkey.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E3FA2.7060408@codemonkey.ws>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 11:28:18AM -0500, Anthony Liguori wrote:
> Within the kernel right (VMCALL is only usable in ring 1).  

Yup.

> Is it 
> terribly important to be able to pass through the syscall arguments in 
> registers verses packing them in a data structure and passing a pointer 
> to that structure?

An arg block would be fine, too.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
