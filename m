Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbZIGJEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbZIGJEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 05:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZIGJEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 05:04:42 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:49568 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZIGJEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 05:04:41 -0400
Date: Mon, 7 Sep 2009 11:04:41 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Catalin Marinas <catalin.marinas@arm.com>, npiggin@suse.de
Subject: Re: linux-next: slab tree build failure
Message-ID: <20090907090441.GB4717@osiris.boeblingen.de.ibm.com>
References: <20090907153723.0c984c83.sfr@canb.auug.org.au>
 <84144f020909062310u37ecdddfw31c6cc9a22ccabd9@mail.gmail.com>
 <20090907173108.3c0148d7.sfr@canb.auug.org.au>
 <1252309426.4964.3.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252309426.4964.3.camel@penberg-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 10:43:46AM +0300, Pekka Enberg wrote:
> Aah, let me guess, CONFIG_SLQB? I guess I'll just rebase the damn tree
> and make it non-default. We need that anyway if we want to merge it to
> 2.6.32. I'll take a stab at it later this evening (my time zone).

Will SLQB be merged during the next merge window? Just realized that s390
doesn't boot with CONFIG_SLQB (crashes before the console is active).

I tend to ignore bugs which seem to be related to SLQB in linux-next,
but if it gets merged I might need to look deeper into this.
