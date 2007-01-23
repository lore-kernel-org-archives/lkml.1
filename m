Return-Path: <linux-kernel-owner+w=401wt.eu-S932977AbXAWL7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977AbXAWL7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 06:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932980AbXAWL7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 06:59:17 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:64142 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977AbXAWL7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 06:59:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LMv9PIZ6fu0bOVWNvuKBM7bked5URFEEeqZLQlcI1dsPJzJc+TRw9+FueJO9D1blX3PFtmCpAhXSAIltwquMOZuqZi0bdFUKtIghhN/DY3z1USKR29u+PfDsojlZ5GxnipoXMY0EV/FTeIJNZn49fpbsqzORVpT18slD63s0EcU=
Message-ID: <9e0cf0bf0701230359s5e18f51amad23f5677bc5cee4@mail.gmail.com>
Date: Tue, 23 Jan 2007 13:59:14 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Alon Bar-Lev" <alon.barlev@gmail.com>,
       "Tomas Carnecky" <tom@dbservice.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@osdl.org>
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
In-Reply-To: <20070123115405.GC20660@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070118141359.GB31418@flint.arm.linux.org.uk>
	 <20070118152326.GC31418@flint.arm.linux.org.uk>
	 <20070122221400.GE6262@strauss.suse.de>
	 <20070122222725.GB32085@flint.arm.linux.org.uk>
	 <9e0cf0bf0701230237j5aa1bbya3a70da314e471b9@mail.gmail.com>
	 <20070123104140.GA20660@flint.arm.linux.org.uk>
	 <9e0cf0bf0701230250nb8d9738redc3e1d963b40bda@mail.gmail.com>
	 <20070123105331.GB20660@flint.arm.linux.org.uk>
	 <9e0cf0bf0701230331v6001f540p4d7b048126ce7fd@mail.gmail.com>
	 <20070123115405.GC20660@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > Rossell, I am confused.
> > There are many places in kernel where there is static __initdata
> > without initialization. Should all these be corrected too? Or your
> > comment applies only to none static global data?
>
> From what I remembered from previous mails on this list (which is what
> caused me to pick up on this), and what I later quoted from the gcc
> manual, all those places (where something is marked __initdata but is
> not explicitly initialised) would appear to be incorrect.
>
> So they should probably be fixed up.

Well... A lot of places in the kernel needs to be fixed, regardless
this patch... I can probably creat a patch for this as well... But
since I don't an expert in this one... We need to be sure this should
be fixed.

Best Regards,
Alon Bar-Lev.
