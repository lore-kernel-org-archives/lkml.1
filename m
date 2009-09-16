Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbZIPSma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbZIPSma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbZIPSmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:42:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42385 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbZIPSmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:42:24 -0400
Date: Wed, 16 Sep 2009 19:38:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Frans Pop <elendil@planet.nl>, Herbert Xu <herbert@gondor.apana.org.au>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] arm: new W macro to WORD_ACCESS
Message-ID: <20090916183847.GA16457@n2100.arm.linux.org.uk>
References: <200909161601.35662.elendil@planet.nl> <20090916175812.GA18993@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916175812.GA18993@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 07:58:12PM +0200, Sebastian Andrzej Siewior wrote:
> leads to a build error because the crypto/cast6.c defines a function
> which is named W.

W has nothing to do with the access size, so this change makes it _really_
confusing.  What it's about is telling the compiler to use the ARM 32-bit
version of the instruction coding when building for Thumb2 (which
can intermix Thumb and ARM instruction sets.)

So the macro needs to be renamed... NAK on this patch as it stands.
