Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbXCZKFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbXCZKFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbXCZKFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:05:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560AbXCZKFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:05:45 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070325213843.GE22126@xi.wantstofly.org> 
References: <20070325213843.GE22126@xi.wantstofly.org>  <20070323111350.GD3980@xi.wantstofly.org> <e9c3a7c20703021312y5f7aa228i5d1c84a8e9ea5676@mail.gmail.com> <20070303111427.GB16944@xi.wantstofly.org> <20070303113305.GB10515@flint.arm.linux.org.uk> <20070321221134.GA22497@xi.wantstofly.org> <tnxlkhpgslz.fsf@arm.com> <16051.1174657433@redhat.com> <20070325211542.GD3593@linux.vnet.ibm.com> 
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, dhowells@redhat.com
Subject: Re: I/O memory barriers vs SMP memory barriers 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 26 Mar 2007 11:04:11 +0100
Message-ID: <3971.1174903451@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennert Buytenhek <buytenh@wantstofly.org> wrote:

> Does everybody agree on these semantics, though?  At least David seems
> to think that mb/rmb/wmb aren't required to order normal memory accesses
> against each other..

Ummm...  I've just realised that your statement here is ambiguous.  When you
say "aren't required to", do you mean "aren't necessary to" or do you mean
"don't have to"?  Isn't English a fun language?

Anyway, what I meant is that mb() and co. as they stand _must_ do everything
smp_mb() and co do respectively, _in_ _addition_ to other side effects.

	mb() implies smp_mb()
	rmb() implies smp_rmb()
	wmb() implies smp_wmb()
	...

David
