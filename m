Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYGGOYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYGGOYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbYGGOYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:24:18 -0400
Received: from sh.osrg.net ([192.16.179.4]:52184 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbYGGOYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:24:17 -0400
Date: Mon, 7 Jul 2008 23:23:39 +0900
To: arjan@infradead.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, mgross@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: move the descriptions of VT-d to
 Documentations/x86/x86_64/boot-options.txt
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080707065816.29833aca@infradead.org>
References: <20080707171707V.fujita.tomonori@lab.ntt.co.jp>
	<20080707065816.29833aca@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080707232337W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008 06:58:16 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 7 Jul 2008 17:17:11 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > Documentations/x86/x86_64/boot-options.txt is the more appropriate
> > place for the descriptions of the VT-d IOMMU kernel parameters.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  Documentation/kernel-parameters.txt       |   22
> > ---------------------- Documentation/x86/x86_64/boot-options.txt |
> 
> 
> I disagree.
> Documentation/kernel-parameters.txt needs to contain ALL of them.

That's fine with me.

Now the descriptions of other x86_64 IOMMUs parameters are in
x86_64/boot-options.txt. That's confusing. I just want to clean up it.


> It already can deal with some of them being only for some
> architectures, but it really should be the one-stop-shop for kernel
> parameters.

Yeah, seems that only x86 and m64k have the own kernel parameters
file. I think that it would be better to merge them into
Documentation/kernel-parameters.txt. Or splitting
Documentation/kernel-parameters.txt cleanly (such as making a
kernel-parameters directory) would be nice too since the file is
huge.
