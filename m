Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbZHFPrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbZHFPrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbZHFPrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:47:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48025 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484AbZHFPrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:47:12 -0400
Date: Thu, 6 Aug 2009 18:45:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       alacrityvm-devel@lists.sourceforge.net, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers Reply-To:
Message-ID: <20090806154543.GA11944@redhat.com>
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <4A7AE150.7040009@redhat.com> <4A7AAB1A0200005A00051BED@sinclair.provo.novell.com> <200908061740.04276.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908061740.04276.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 05:40:04PM +0200, Arnd Bergmann wrote:
> 3. The ioq method seems to be the real core of your work that makes
> venet perform better than virtio-net with its virtqueues. I don't see
> any reason to doubt that your claim is correct. My conclusion from
> this would be to add support for ioq to virtio devices, alongside
> virtqueues, but to leave out the extra bus_type and probing method.
> 
> 	Arnd <><

The fact that it's in kernel also likely contributes.

-- 
MST
