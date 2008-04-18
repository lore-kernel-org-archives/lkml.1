Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbYDRSBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbYDRSBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759009AbYDRSBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:01:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:17667 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758888AbYDRSBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VPTl+FoAabMhabu/K+JjFa3GDzRw2lugdBH/CglVxfpQFDI/YYjj7od3WWBjpZcVHxGYuSr9bWqrilEFDxANWL2E1GiJ7kl2canw0boaSc1Q05pJKhebqycBudojnWM8TUYdiTfBqdj/iB5slGepv01n7+jgHgzU6VVrq8K5Ygk=
Message-ID: <6bc632150804181101i701f220an20dddf54389be273@mail.gmail.com>
Date: Fri, 18 Apr 2008 23:31:29 +0530
From: "pradeep singh rautela" <rautelap@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH 5/5] tun: vringfd xmit support.
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Max Krasnyansky" <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org
In-Reply-To: <2c0942db0804180725h88fa7d1mb8e85e5a8b0aede6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181433.48488.rusty@rustcorp.com.au>
	 <200804181441.10499.rusty@rustcorp.com.au>
	 <200804181442.17251.rusty@rustcorp.com.au>
	 <200804181443.24812.rusty@rustcorp.com.au>
	 <6bc632150804180446u29e5dae9h986e1d255e584d21@mail.gmail.com>
	 <2c0942db0804180725h88fa7d1mb8e85e5a8b0aede6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 7:55 PM, Ray Lee <ray-lk@madrabbit.org> wrote:
> On Fri, Apr 18, 2008 at 4:46 AM, pradeep singh rautela
>  <rautelap@gmail.com> wrote:
>  >
>  > On Fri, Apr 18, 2008 at 10:13 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> >  >  +               /* How many pages will this take? */
>  >  >  +               npages = 1 + (base + len - 1)/PAGE_SIZE - base/PAGE_SIZE;
>  >
>  >  Hi Rusty,
>  >  A trivial suggestion, how about
>  >           npages = 1+(len -1)/PAGE_SIZE ?
>
>  That's not the same. In particular, his version accounts for the
>  fractional page at the beginning, while yours doesn't.

Oh thanks for correcting me Ray. :)
>
>  While it's tempting to use algebra to simplify things, it's not safe
>  to do so when the expression involves division over the integers. The
>  only care-free integer math in a computer is subtraction and ++.

I stand corrected.

Sorry for noise.

Thanks,
-- 
Pradeep Singh Rautela
http://eagain.wordpress.com
http://emptydomain.googlepages.com
