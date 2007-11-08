Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbXKHC1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbXKHC1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760164AbXKHC1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:27:40 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:47031 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbXKHC1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:27:39 -0500
Date: Thu, 8 Nov 2007 13:27:37 +1100
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32 build failure - !CONFIG_PPC_ISERIES
Message-ID: <20071108022737.GQ24243@bakeyournoodle.com>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org> <473226A3.7090704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <473226A3.7090704@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 02:27:07AM +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The kernel build fails with randconfig, with following error
> 
>   CC      arch/powerpc/platforms/celleb/setup.o
> arch/powerpc/platforms/celleb/setup.c:151: error: ‘generic_calibrate_decr’ undeclared here (not in a function)
> make[2]: *** [arch/powerpc/platforms/celleb/setup.o] Error 1
> make[1]: *** [arch/powerpc/platforms/celleb] Error 2
> make: *** [arch/powerpc/platforms] Error 2


I think you need this patch:
	http://patchwork.ozlabs.org/linuxppc/patch?q=Tony%20Breeds&id=14462

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

