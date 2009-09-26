Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZIZUD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZIZUD3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 16:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZIZUD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 16:03:28 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:42935 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982AbZIZUD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 16:03:27 -0400
X-Trace: 266844257/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.58.251/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.58.251
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnQFANoPvkpPRTr7/2dsb2JhbACBUNJihB4F
X-IronPort-AV: E=Sophos;i="4.44,457,1249254000"; 
   d="scan'208";a="266844257"
Date: Sat, 26 Sep 2009 21:03:27 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Christoph Hellwig <hch@lst.de>
cc: Michal Simek <michal.simek@petalogix.com>, linux-arch@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill USE_ELF_CORE_DUMP
In-Reply-To: <20090926195010.GA24592@lst.de>
Message-ID: <Pine.LNX.4.64.0909262059200.21273@sister.anvils>
References: <20090423183331.GA19899@lst.de> <49F16786.7010401@petalogix.com>
 <20090926195010.GA24592@lst.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Sep 2009, Christoph Hellwig wrote:

> Currently all architectures but microblaze unconditionally define
> USE_ELF_CORE_DUMP.  The microblaze ommision seems like an error to
> me, so let's  kill this ifdef and make sure we are the same everywhere.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yes, I came to a similar conclusion when I added get_dump_page():
#ifdef'ed it on CONFIG_ELF_CORE, but couldn't see the point of
USE_ELF_CORE_DUMP. (Though I missed the microblaze omission).

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
