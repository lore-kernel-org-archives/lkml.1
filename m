Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbYJPFX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbYJPFX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 01:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbYJPFXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 01:23:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:56369 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbYJPFXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 01:23:14 -0400
Subject: Re: powerpc allmodconfig
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, bzolnier@gmail.com, marek.vasut@gmail.com,
       tiwai@suse.de, netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ralf@linux-mips.org,
       mark.fasheh@oracle.com, linuxppc-dev@ozlabs.org,
       linux-ide@vger.kernel.org, dan.j.williams@intel.com,
       linux-ext4@vger.kernel.org, dwmw2@infradead.org, mchehab@infradead.org
In-Reply-To: <20081015.220247.262683261.davem@davemloft.net>
References: <20081015213337.a99a9595.akpm@linux-foundation.org>
	 <20081015.220247.262683261.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 16:21:47 +1100
Message-Id: <1224134507.8157.551.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-15 at 22:02 -0700, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, 15 Oct 2008 21:33:37 -0700
> 
> > kernel/resource.c: In function '__reserve_region_with_split':
> > kernel/resource.c:554: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
> > kernel/resource.c:554: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
> > kernel/resource.c:554: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'resource_size_t'
> > kernel/resource.c:554: warning: format '%llx' expects type 'long long unsigned int', but argument 7 has type 'resource_size_t'
> 
> Known issue, Ben wants to add a new variant of %pX in order to print resources so that
> resource_size_t vs. unsigned long stuff doesn't matter like this any more.

Actually, I was told Linus had one and I've been trying to dig it out...

Oh well, I may as well dig my own old one.

Cheers,
Ben.


