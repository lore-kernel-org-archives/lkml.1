Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbYGHK0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbYGHK0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 06:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYGHK0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 06:26:23 -0400
Received: from mga07.intel.com ([143.182.124.22]:54537 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbYGHK0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 06:26:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,322,1212390000"; 
   d="scan'208";a="8481649"
Subject: Re: FW: [Fwd: [PATCH]Using Intel CRC32 instruction to implement
	hardware accelerated CRC32c algorithm.]
From: austin zhang <austin_zhang@linux.intel.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net, chaapala@cisco.com, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com
In-Reply-To: <000901c8e0d4$6f5cf230$7fb410ac@ccr.corp.intel.com>
References: <000901c8e0d4$6f5cf230$7fb410ac@ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Jul 2008 06:25:54 -0400
Message-Id: <1215512754.2906.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, ﻿Herbert, see my reply as below.
> 1) Utilise the brand new crypto ahash interface (note that it's
﻿When you mentioned ahash, can you give a explanation on it? 
The brand new crypto interface is different with crypto/api?
> designed to support sync just as well as async despite the name)
﻿Do you mean use async_xxx interface?
> to rewrite the crypto/crc32c implementation such that one tfm can
> be used by multiple users.  All that has to be done is to move
> the state from the tfm into the request object.
 
> 2) Convert all crc32c users to use the crypto interface and phase
> out lib/crc32c completely.
> 
> 3) Add the Intel-specific crc32c implementation through the crypto
> API.
Agreed. And which module in crypto is the template for following the crypto API?

> That way none of this iffy testing will be necessary.  Even better,
> most users can share one common tfm and therefore there will only
> be one test for the CPU flag at boot time rather than every time
> it's used.
> 
> In fact, we could even skip 2) and reimplement lib/crc32c as a
> wrapper on the crypto crc32c interface with a shared tfm so you
> don't need to modify its existing users.
Good idea.
> Cheers,

