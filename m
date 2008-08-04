Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYHDKpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYHDKpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYHDKpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:45:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39574 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYHDKpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:45:33 -0400
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
From: David Woodhouse <dwmw2@infradead.org>
To: Austin Zhang <austin_zhang@linux.intel.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <1217846139.20845.25.camel@localhost.localdomain>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217844725.3454.580.camel@pmac.infradead.org>
	 <1217846139.20845.25.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 11:45:26 +0100
Message-Id: <1217846726.3454.589.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 06:35 -0400, Austin Zhang wrote:
> On Mon, 2008-08-04 at 11:12 +0100, David Woodhouse wrote:
> > You could perhaps just use 'unsigned long' here, to avoid the ifdef.
> Thanks. 
> > And it would be nice if we could make libcrc32c use this too, rather
> > than just the 'crypto' users.
> From previous discussing, herbert would like to transfer the libcrc32c 
> interface by new crypto because there were few user using the current 
> libcrc32c interface. 

Are we deprecating libcrc32c, then? Or just turning it into a wrapper
around the crypto code?

Either way, does it really make sense to force all crc32 users to pull
in the whole crypto framework? Some may get fractious about that...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



