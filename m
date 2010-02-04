Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab0BDANF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:13:05 -0500
Received: from sh.osrg.net ([192.16.179.4]:53390 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757932Ab0BDAM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:12:59 -0500
Date: Thu, 4 Feb 2010 09:12:06 +0900
To: mitov@issp.bas.bg
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu,
       davej@redhat.com
Subject: Re: [BUG] agpgart-amd64 not initialized in 2.6.33-rc5 if
 iommu=allowed in kernel command line
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201002031719.48603.mitov@issp.bas.bg>
References: <20100202202328O.fujita.tomonori@lab.ntt.co.jp>
	<20100203004905T.fujita.tomonori@lab.ntt.co.jp>
	<201002031719.48603.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100204091147R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 04 Feb 2010 09:12:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 17:19:48 +0200
Marin Mitov <mitov@issp.bas.bg> wrote:

> In this configuration (both patches applied) it works for me with/without kernel 
> command line (iommu=allowed + ....) when either amd64-agp is built in the kernel 
> (CONFIG_AGP_AMD64=y), or as a module (CONFIG_AGP_AMD64=m).

Great, thanks a lot!

I've just resent the patch in the proper format.


> > > > lsmod output:
> > > > 
> > > > amd64_agp               7463  1
> > > > agpgart                   27765  1 amd64_agp
> 
> I have still amd64_agp used, so I cannot test load/unload  amd64_agp:

I work on it if someone reports a problem about it.
