Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYHDK7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYHDK7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYHDK7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:59:46 -0400
Received: from mga06.intel.com ([134.134.136.21]:63893 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752568AbYHDK7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:59:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,304,1215414000"; 
   d="scan'208";a="425714913"
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
From: Austin Zhang <austin_zhang@linux.intel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <1217846726.3454.589.camel@pmac.infradead.org>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217844725.3454.580.camel@pmac.infradead.org>
	 <1217846139.20845.25.camel@localhost.localdomain>
	 <1217846726.3454.589.camel@pmac.infradead.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 04 Aug 2008 06:58:01 -0400
Message-Id: <1217847481.20845.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 11:45 +0100, David Woodhouse wrote:
> Are we deprecating libcrc32c, then? Or just turning it into a wrapper
> around the crypto code?
Maybe I can pick up ﻿crc32c_intel_le_hw_byte and ﻿crc32c_intel_le_hw
into 
one arch-related file and make the current new crypto  interface and
libcrc32c
call it.
> Either way, does it really make sense to force all crc32 users to pull
> in the whole crypto framework? Some may get fractious about that...
If there were really few (or no) user using that previous interface, it will
be reasonable to merge the crc32c totally into crypto subsystem as a
digest method.
And I remembered Herbert had mentioned he will convert those previous
interface 
calling to new crypto API. For the crc32c, he had done for it.

BTW, why did I always got each email on this thread twice:(? (the same
email twice) 

