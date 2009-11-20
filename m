Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZKTQcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZKTQcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZKTQcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:32:14 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51034 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZKTQcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:32:13 -0500
Message-ID: <4B06C47A.6030403@austin.ibm.com>
Date: Fri, 20 Nov 2009 10:31:54 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Michal Simek <michal.simek@petalogix.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: microblaze tree build failure
References: <20091120095622.5fefb9fa.sfr@canb.auug.org.au>
In-Reply-To: <20091120095622.5fefb9fa.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, this should be rejected.  I have submitted an updated patch to
linuxppc-dev and devicetree-discuss.

I'm not sure how this patch git picked up, I didn't think it did.
Looking at the coimmit it appears that only patch 1/4 of the patchset
was picked up.

-Nathan Fontenot

Stephen Rothwell wrote:
> Hi Michal,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> arch/powerpc/platforms/built-in.o: In function `.ofdt_write':
> reconfig.c:(.text+0xca08): undefined reference to `.of_attach_node'
> arch/powerpc/platforms/built-in.o: In function `.do_device_node':
> vio.c:(.text+0x1be2c): undefined reference to `.of_attach_node'
> 
> Caused by commit 5d0c1c076548e1f8d590a2f70f281b4eb7b3aeb2 ("Merge
> of_attach_node") which I have reverted for today.  That patch is missing
> an update to drivers/of/Makefile at least ... and probably some other
> stuff as well.
> 
