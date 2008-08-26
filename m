Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbYHZWyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbYHZWyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYHZWyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:54:31 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:45979 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYHZWya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ol1LrEorzD52g/OG6zsbkWvi02niBCiBRLiq30LKCcxY3PcYLM+pcik0TsIvqf+YGe
         C68Gxz/lPo8eeyU6cJrw1IxvLTatR3p0ECgsOlRVu+vjwgEeB6MZGD3mjTlmiNM9xrOp
         cKLKSmpbNGUmHxpBcn+OqY7OZmOtyErVtwNJ4=
Message-ID: <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
Date: Tue, 26 Aug 2008 18:54:28 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Cc: "Adrian Bunk" <bunk@stusta.de>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, linux-embedded@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com>
	 <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
	 <200808261111.19205.rusty@rustcorp.com.au>
	 <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
	 <20080826183051.GB10925@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	 <20080826205916.GB11734@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 5:04 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> And embedded people (the ones that might care about 1% code size) are the
> ones that would also want smaller stacks even more!

This is something I never understood - embedded devices are not going
to run more than a few processes and 4K*(Few Processes)
 IMHO is not worth a saving now a days even in embedded world given
falling memory prices. Or do I misunderstand?

Parag
