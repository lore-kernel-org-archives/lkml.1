Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbYFBL5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbYFBL5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYFBL5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:57:40 -0400
Received: from gw.goop.org ([64.81.55.164]:52483 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbYFBL5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:57:39 -0400
Message-ID: <4843E00C.1080407@goop.org>
Date: Mon, 02 Jun 2008 12:57:00 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] paravirt: add hooks for	ptep_modify_prot_start/commit
References: <patchbomb.1212192268@localhost> <5bed0127be5f509fd686.1212192270@localhost> <20080602111249.GA18586@elte.hu>
In-Reply-To: <20080602111249.GA18586@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> +#define  __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
>>     
>
> please turn this into CONFIG_ARCH_HAS_PTEP_MODIFY_PROT_TRANSACTION 
> instead.

The __HAVE_ARCH_ form is consistent with all the other conditional 
things in asm/pgtable.h, like __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS, 
__HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG, etc.  I don't think adding 
CONFIG_ARCH_HAS_ for this one case is a good idea.

    J
