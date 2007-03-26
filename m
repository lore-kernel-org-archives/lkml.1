Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbXCZKI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbXCZKI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbXCZKI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:08:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbXCZKI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:08:28 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1174767387.10836.107.camel@localhost.localdomain> 
References: <1174767387.10836.107.camel@localhost.localdomain>  <20070323111350.GD3980@xi.wantstofly.org> <e9c3a7c20703021312y5f7aa228i5d1c84a8e9ea5676@mail.gmail.com> <20070303111427.GB16944@xi.wantstofly.org> <20070303113305.GB10515@flint.arm.linux.org.uk> <20070321221134.GA22497@xi.wantstofly.org> <tnxlkhpgslz.fsf@arm.com> <16051.1174657433@redhat.com> 
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, paulmck@us.ibm.com
Subject: Re: I/O memory barriers vs SMP memory barriers 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 26 Mar 2007 11:07:23 +0100
Message-ID: <4039.1174903643@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> Hrm... I'm not sure I like the io_* name, I think it's even more
> confusing, people will never know when to use what ...

I'd've thought it more obvious, but given there are several types of I/O, some
of which might require different barriering to others, I can see your point.

However, I think mb() unadorned is also confusing.

> Maybe we should dig out again my attempt at properly defining semantics
> of IO accessors and related barriers and extend it to include CPU vs.
> DMA barriers.

That could be useful.

David
