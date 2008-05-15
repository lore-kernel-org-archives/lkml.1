Return-Path: <linux-kernel-owner+w=401wt.eu-S1760894AbYEOXnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbYEOXnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 19:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbYEOXnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 19:43:24 -0400
Received: from ozlabs.org ([203.10.76.45]:33930 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbYEOXnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 19:43:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: Virt RNG?
Date: Fri, 16 May 2008 09:43:08 +1000
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       jeremy@xensource.com, Herbert Xu <herbert@gondor.apana.org.au>,
       Avi Kivity <avi@qumranet.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>
References: <482C8595.5030509@garzik.org>
In-Reply-To: <482C8595.5030509@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805160943.08788.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2008 04:48:53 Jeff Garzik wrote:
> Has anyone yet written a "hw" RNG module for virt, that reads the host's
> random number pool?
>
> All this talk[1] about IRQF_SAMPLE_RANDOM in network drivers reminds me
> that virt guest instances should be grabbing random numbers from the
> host, especially if the host has a hardware RNG.

Yes, I prepared one earlier.  I was a little surprised to see that hwrng 
drivers don't contribute in any way to the entropy pool though, but now
reading the thread I find out about rngd (not installed on my Ubuntu system, 
but available at least).

One could argue that virtual rng should try to feed the kernel rng directly, 
with or without entropy credit.

Anyway, since there's interest, I'll drag virtio_rng from the bottom of the 
queue, apply Christian's fix (which I somehow missed before, sorry 
Christian), and re-post.

Thanks,
Rusty.
