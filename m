Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbZLVHXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbZLVHXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 02:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZLVHXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 02:23:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbZLVHXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 02:23:00 -0500
Date: Tue, 22 Dec 2009 09:22:13 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
Message-ID: <20091222072213.GY4490@redhat.com>
References: <4B1D4F29.8020309@gmail.com>
 <20091218215107.GA14946@elte.hu>
 <4B2F9582.5000002@gmail.com>
 <4B2F978D.7010602@redhat.com>
 <4B2F9C85.7070202@gmail.com>
 <4B2FA42F.3070408@codemonkey.ws>
 <4B2FA655.6030205@gmail.com>
 <4B2FAE7B.9030005@codemonkey.ws>
 <4B2FB3F1.5080808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2FB3F1.5080808@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 12:44:17PM -0500, Gregory Haskins wrote:
> >  They should be relatively rare
> > because obtaining good receive batching is pretty easy.
> 
> Batching is poor mans throughput (its easy when you dont care about
> latency), so we generally avoid as much as possible.
> 
> > Considering
> > these are lightweight exits (on the order of 1-2us),
> 
> APIC EOIs on x86 are MMIO based, so they are generally much heavier than
> that.  I measure at least 4-5us just for the MMIO exit on my Woodcrest,
> never mind executing the locking/apic-emulation code.
> 
With x2apic EOIs are not MMIO any longer.

--
			Gleb.
