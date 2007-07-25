Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbXGYQQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbXGYQQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760215AbXGYQQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:16:10 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:45600 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbXGYQQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:16:09 -0400
Date: Wed, 25 Jul 2007 12:15:44 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 0/8]KVM: swap out guest pages
Message-ID: <20070725161544.GA7747@c2.user-mode-linux.org>
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com> <46A4829C.9080104@qumranet.com> <20070723200659.GA13508@c2.user-mode-linux.org> <46A58CAD.7070807@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A58CAD.7070807@qumranet.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 08:22:53AM +0300, Avi Kivity wrote:
> Even in the current model, guest physical memory is mmap()ed into host
> userspace.

I want it to be identity-mapped, which a single address space would
guarantee.  For things which change mappings, like vmalloc, I need to
be in the same address space as the guest.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
