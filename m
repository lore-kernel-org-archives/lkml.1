Return-Path: <linux-kernel-owner+w=401wt.eu-S935841AbZDBLIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935841AbZDBLIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935197AbZDBLHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:07:50 -0400
Received: from sh.osrg.net ([192.16.179.4]:50109 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934810AbZDBLHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:07:49 -0400
Date: Thu, 2 Apr 2009 20:06:26 +0900
To: joerg.roedel@amd.com
Cc: shemminger@vyatta.com, davej@redhat.com, tglx@linuxtronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [Bug 487894] New: sky2 0000:06:00.0: DMA-API: device driver
	frees DMA memory with different size
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090402105415.GD21083@amd.com>
References: <20090401172708.GA11941@redhat.com>
	<20090401110245.4d1ddf72@nehalam>
	<20090402105415.GD21083@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090402200634I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 02 Apr 2009 20:06:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 12:54:15 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Wed, Apr 01, 2009 at 11:02:45AM -0700, Stephen Hemminger wrote:
> > 
> > The sky2 driver uses pci_unmap_len and pci_unmap_len_set which on 32 bit
> > platforms are meaningless so they are stubbed out. 
> > Basically, DMA-API checks are wrong/bogus to enforce on 32bit x86 as is.
> 
> As far as I know the VT-d driver is available on 32 bit x86 too. So this should
> not always be a nop.

VT-d is available on only x86_64.

