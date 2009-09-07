Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbZIGHnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbZIGHnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 03:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZIGHnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 03:43:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50980 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZIGHnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 03:43:46 -0400
Subject: Re: linux-next: slab tree build failure
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Catalin Marinas <catalin.marinas@arm.com>, npiggin@suse.de
In-Reply-To: <20090907173108.3c0148d7.sfr@canb.auug.org.au>
References: <20090907153723.0c984c83.sfr@canb.auug.org.au>
	 <84144f020909062310u37ecdddfw31c6cc9a22ccabd9@mail.gmail.com>
	 <20090907173108.3c0148d7.sfr@canb.auug.org.au>
Date: Mon, 07 Sep 2009 10:43:46 +0300
Message-Id: <1252309426.4964.3.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, 7 Sep 2009 09:10:18 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > AFAICT, you're interested in kmemleak.git, not slab.git. Catalin?

On Mon, 2009-09-07 at 17:31 +1000, Stephen Rothwell wrote:
> I first got the error after merging the slab tree ... the kmemleak tree
> is merged much later.

Aah, let me guess, CONFIG_SLQB? I guess I'll just rebase the damn tree
and make it non-default. We need that anyway if we want to merge it to
2.6.32. I'll take a stab at it later this evening (my time zone).

			Pekka

