Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbZHLC1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbZHLC1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 22:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZHLC1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 22:27:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:61426 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZHLC1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 22:27:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,364,1246863600"; 
   d="scan'208";a="715981155"
Subject: Re: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <1249524767.24238.318.camel@yhuang-dev.sh.intel.com>
References: <1249285483-22286-1-git-send-email-ying.huang@intel.com>
	 <20090805094506.GA12528@gondor.apana.org.au>
	 <1249524767.24238.318.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 10:27:00 +0800
Message-Id: <1250044020.5337.214.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 10:12 +0800, Huang Ying wrote:
> On Wed, 2009-08-05 at 17:45 +0800, Herbert Xu wrote:
> > On Mon, Aug 03, 2009 at 03:44:43PM +0800, Huang Ying wrote:
> > > When doing "modeprobe tcrypt mode=10", the following error will show
> > > in dmesg.
> > > 
> > > alg: skcipher: Failed to load transform for ctr(aes): -22
> > > alg: skcipher: Failed to load transform for ctr(aes): -22
> > > tcrypt: one or more tests failed!
> > 
> > I can't reproduce it here:
> > 
> > etch1:~# modprobe tcrypt mode=10
> > FATAL: Error inserting tcrypt (/lib/modules/2.6.30/kernel/crypto/tcrypt.ko): Resource temporarily unavailable
> > etch1:~# dmesg|tail
> > alg: No test for digest_null (digest_null-generic)
> > alg: No test for compress_null (compress_null-generic)
> > padlock: VIA PadLock Hash Engine not detected.
> > padlock: VIA PadLock Hash Engine not detected.
> > eth0: link up, 100Mbps, full-duplex, lpa 0x05E1
> > Initializing XFRM netlink socket
> > NET: Registered protocol family 17
> > NET: Registered protocol family 10
> > lo: Disabled Privacy Extensions
> > eth0: no IPv6 routers present
> > etch1:~# 
> > 
> > The tcrypt test shouldn't use geniv at all.
> > 
> > What kernel version was this?
> 
> The version is: v2.6.30-6814-gab30046. Kernel config is attached too.

Any follow-up for this patch? Still can not re-produce?

Best Regards,
Huang Ying


