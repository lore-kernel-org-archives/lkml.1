Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbYGJL1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbYGJL1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 07:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYGJL1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 07:27:05 -0400
Received: from mga10.intel.com ([192.55.52.92]:37063 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751653AbYGJL1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 07:27:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,338,1212390000"; 
   d="scan'208";a="351756380"
Subject: Re: FW: [Fwd: [PATCH]Using Intel CRC32 instruction to implement
	hardware accelerated CRC32c algorithm.]
From: austin zhang <austin_zhang@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, johnpol@2ka.mipt.ru
Cc: davem@davemloft.net, chaapala@cisco.com, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com
In-Reply-To: <20080709074153.GA11927@gondor.apana.org.au>
References: <000901c8e0d4$6f5cf230$7fb410ac@ccr.corp.intel.com>
	 <1215512754.2906.23.camel@localhost.localdomain>
	 <20080709074153.GA11927@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 10 Jul 2008 07:26:09 -0400
Message-Id: <1215689169.5257.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-09 at 15:41 +0800, Herbert Xu wrote:

> I've just converted the crc32c module over to the new interface.
> You can use this as an example.
Herbert and ﻿Evgeniy,
Sorry for late reply. Thanks a lot for your information and example, I
will work out the intel-specific implemetation. After internal
discussing and approval, I will post here for review again.

> Unfortunately this leads to nasty hacks because the existing
> interface does chaining in a way that isn't easily mapped over
> to the crypto API.  However this is no great loss since there
> is a grand total of two users in the tree :)
> 
> So my plan is to convert them and then remove the libcrc32c
> interface completely.
Because libcrc32c can be a module in original implemetation, so for
those other routine which call crc32c_le directly, this may not work for
them?  


