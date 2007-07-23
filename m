Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbXGWUHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbXGWUHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757673AbXGWUHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:07:33 -0400
Received: from [198.99.130.12] ([198.99.130.12]:37178 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbXGWUHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:07:32 -0400
Date: Mon, 23 Jul 2007 16:06:59 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 0/8]KVM: swap out guest pages
Message-ID: <20070723200659.GA13508@c2.user-mode-linux.org>
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com> <46A4829C.9080104@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A4829C.9080104@qumranet.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 01:27:40PM +0300, Avi Kivity wrote:
> Having an address_space (like your patch does) is remarkably simple, and 
> requires few hooks from the current vm.  However using existing vmas 
> mapped by the user has many advantages:

It's also needed for a SKAS-like UML client, where the host side will
need to make system calls on behalf of the guest.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
