Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbXC1Efk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbXC1Efk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 00:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbXC1Efk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 00:35:40 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46321 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbXC1Efj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 00:35:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 8/21] MSI: Remove msi_cache
References: <20070322105339.D3A36DDF53@ozlabs.org>
Date: Tue, 27 Mar 2007 22:35:05 -0600
In-Reply-To: <20070322105339.D3A36DDF53@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:36 +1100")
Message-ID: <m1zm5yrnnq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> We don't need a special cache just for msi descriptors. They're not
> particularly large, under 100 bytes for sure, and don't seem to require any
> special alignment etc. On most systems there will be relatively few MSIs,
> and hence we waste most of a page on the cache. Better to just kzalloc the
> space for the few we do need.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
