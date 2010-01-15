Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0AOMDO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 07:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757122Ab0AOMDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 07:03:14 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34268 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab0AOMDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 07:03:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jIukwQpYpuU2od7BaPKyHWxh2VnYrS/FUpoOsyKReIhJGjQmbViFNIjS7SLEtVWkSf
         gWitweEAmeBpyO/xh5XWMiYvuQZZ2us+yY6ssheO295mLDslmLEzLDJhj0ZaiyHpyblA
         8X6qqJGaofV52SaO2K2idj+wq3aekuWlck7yE=
Date: Fri, 15 Jan 2010 15:03:09 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Christian Kujau <lists@nerdbynature.de>, Brian Gerst <brgerst@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
	tables
Message-ID: <20100115120309.GB5412@lenovo>
References: <20100106112133.GA5815@lenovo> <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de> <4B4633D3.2070903@zytor.com> <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de> <20100108215039.GD4967@lenovo> <73c1f2161001091750y67a852dfk7539021dcc82fa1f@mail.gmail.com> <20100110080940.GB5189@lenovo> <1263128343.2393.45.camel@cthulhu.hellion.org.uk> <alpine.DEB.2.01.1001150011480.3483@bogon.housecafe.de> <1263554950.16526.27033.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263554950.16526.27033.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 11:29:10AM +0000, Ian Campbell wrote:
...
> 
> > Cyrill: with your patch alone (for arch/x86/kernel/process.c), the DomU
> > is still not booting, Dom0 "xm dmesg" reporting the same error. As it's
> > working with both patches applied, should I try to test with only Ian's
> > patch (for arch/x86/xen/enlighten.c) applied?
> 
> It's OK, both patches are definitely required to fix 64 bit guests so
> there is no point in testing just one or the other.
> 

ah, ok, so be it. Thanks!

> Ian.
> 
> -- 
> Ian Campbell
> Current Noise: Exodus - Scar Spangled Banner
> 
> War is much too serious a matter to be entrusted to the military.
> 		-- Clemenceau
> 
	-- Cyrill
