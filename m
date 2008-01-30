Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbYA3NAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbYA3NAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbYA3NAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:00:05 -0500
Received: from hs-out-0708.google.com ([64.233.178.244]:46703 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753584AbYA3NAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:00:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bBBarfPkEXQ2CYowXEVaFpiC7zTsfduX49eJtsF3WMZeImBSQ54nO84pjvisLMXVi+PcwEhPXweKBRDvLJ33YXHEES8gVcbRKOfAkTyWuRd32YmCZfRbp2zNo4tm23fA6TyHNFkCsWPOSdi9ygCWjzNk2HJdSQIwiisUlAP3sJw=
Message-ID: <851fc09e0801300500p3efe8602yd3219e44856486f9@mail.gmail.com>
Date: Wed, 30 Jan 2008 21:00:00 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: ioremap_xxx() with EXEC enabled
Cc: "Huang, Ying" <ying.huang@intel.com>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200801301059.40568.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201685530.17912.11.camel@caritas-dev.intel.com>
	 <200801301059.40568.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 5:59 PM, Andi Kleen <ak@suse.de> wrote:
> On Wednesday 30 January 2008 10:32, Huang, Ying wrote:
> > Hi,
> >
> > On i386, EFI may need to map EFI runtime code area as EXEC enabled with
> > ioremap(). But, I found that the memory are mapped as EXEC disabled when
> > mapped with ioremap() now. I think we may need a method to map memory
> > area as EXEC enabled with ioremap_xxx(). Some possible interface schemes
> > for mapping as EXEC enabled are as follow:
>
> Does __ioremap(..., PAGE_KERNEL_EXEC) not work?

The the last parameter of the current implementation of __ioremap() in
x86 git is  enum ioremap_mode (IOR_MODE_UNCACHED and IOR_MODE_CACHED),
not the flags like before. So this does not work.

Best Regards,
Huang Ying
