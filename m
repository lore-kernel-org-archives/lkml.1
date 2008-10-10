Return-Path: <linux-kernel-owner+w=401wt.eu-S1763341AbYJJTLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763341AbYJJTLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762782AbYJJTLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:11:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:61539 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762331AbYJJTLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KiykR4kvL+576kgmvUDBIYTQQsTXvj/OYTIm1CJn68YObJbGxrw2QPG4XaYKu93ayN
         tXO7g47032gZkGjYesODeZ2se4/OGLljc6tZNJ6+pwac3+drtAoUM3rd/zJGAm9vhcMw
         XqlScSVI1vxWBG+Pt5+RJwD+BP3H9lWmmi3Zg=
Date: Fri, 10 Oct 2008 23:11:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: apic - unify APIC_DIVISOR
Message-ID: <20081010191127.GA31036@localhost>
References: <20081010150017.GD7328@localhost> <7E82351C108FA840AB1866AC776AEC46378236B8@orsmsx505.amr.corp.intel.com> <20081010163101.GG7328@localhost> <7E82351C108FA840AB1866AC776AEC46378238AE@orsmsx505.amr.corp.intel.com> <20081010171645.GI7328@localhost> <20081010190350.GA25931@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010190350.GA25931@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Venki Pallipadi - Fri, Oct 10, 2008 at 12:03:50PM -0700]
...
| 
| If there is no pressing reason to change the initial calibration value, how
| about the simple patch below.
| 
| The 10^9 value that is used for 100 mS calibration time is pretty big as
| tglx's comment points out. We will only underflow it if there is a
| bus clock running at 10 GHz * 16 = 160 Ghz.
| 
| This way we will not fix something that is not really broken today and will not
| break in foreseeable future.
| 
| Thanks,
| Venki

I personally have no objection. Thanks Venki.
Btw since Ingo already picked the patch from me
maybe you could make a patch with numbers you mentoined
(ie changelog) and fix 0xffffffff to 10^9?
 
		- Cyrill -
