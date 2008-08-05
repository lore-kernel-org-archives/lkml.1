Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbYHEJzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbYHEJzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbYHEJxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:53:23 -0400
Received: from mga06.intel.com ([134.134.136.21]:10367 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753234AbYHEJxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:53:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,309,1215414000"; 
   d="scan'208";a="323231026"
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
From: Austin Zhang <austin_zhang@linux.intel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <1217859214.3454.629.camel@pmac.infradead.org>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217859214.3454.629.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 05:51:34 -0400
Message-Id: <1217929894.1613.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 15:13 +0100, David Woodhouse wrote:
> Am I missing something here, or are you registering the crypto algorithm
> _unconditionally_ and then just causing init requests for it to fail on
> older hardware?  Wouldn't it be better to register the driver _only_
> when the hardware is capable? Or at least "if at least one cpu is
> capable".
Thanks, I will move it to module init.
> I think that should depend on CONFIG_X86? 
Thanks.

