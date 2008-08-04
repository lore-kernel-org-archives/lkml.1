Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYHDOUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYHDOUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbYHDOUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:20:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:42584 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbYHDOUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:20:21 -0400
Date: Mon, 4 Aug 2008 07:20:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Austin Zhang <austin_zhang@linux.intel.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
 algorithm by new crypto API.
Message-ID: <20080804072015.0fcd23e7@infradead.org>
In-Reply-To: <20080804140435.GA11227@gondor.apana.org.au>
References: <1217842507.20845.18.camel@localhost.localdomain>
	<1217844725.3454.580.camel@pmac.infradead.org>
	<1217846139.20845.25.camel@localhost.localdomain>
	<1217846726.3454.589.camel@pmac.infradead.org>
	<20080804140435.GA11227@gondor.apana.org.au>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 22:04:35 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> There only three crc32c users in the kernel tree and the crypto
> interface will serve the perfectly.

isn't it a bit heavy for something as simple as a crc?
(which after all is one instruction now ;0)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
