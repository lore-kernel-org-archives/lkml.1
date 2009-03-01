Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbZCASEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbZCASEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 13:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbZCASEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 13:04:25 -0500
Received: from imta-38.everyone.net ([216.200.145.38]:40841 "EHLO
	omta0110.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754252AbZCASEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 13:04:24 -0500
X-Eon-Dm: dm0206
X-Eon-Sig: AQHOS7NJqs4la6syKAIAAAAH,9d389c8baf1ee3de4362c2ab0d1fd57b
Date: Sun, 1 Mar 2009 13:04:20 -0500
From: "Kevin O'Connor" <kevin@koconnor.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Reinauer <stepan@coresystems.de>, linux-kernel@vger.kernel.org,
       coreboot@coreboot.org, Jaswinder Singh Rajput <jaswinder@infradead.org>
Subject: Re: MPTable can not be high-memory on Linux
Message-ID: <20090301180420.GA27040@morn.localdomain>
References: <499DB40C.1060205@coresystems.de> <499DCE79.8020809@coresystems.de> <20090222152530.GA30576@morn.localdomain> <200902221806.55429.rjw@sisk.pl> <49A1C4AF.9000009@kernel.org> <20090222223226.GA3346@morn.localdomain> <20090222225847.GB1649@elte.hu> <49A23EE0.8000102@kernel.org> <20090228234127.GA29964@morn.localdomain> <49A9FC9A.2030707@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A9FC9A.2030707@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 07:10:18PM -0800, Yinghai Lu wrote:
> Kevin O'Connor wrote:
> > On Sun, Feb 22, 2009 at 10:14:56PM -0800, Yinghai Lu wrote:
> >> please check
> >>
> >> [PATCH] x86: check physptr with max_low_pfn on 32bit
> > 
> > Thanks for looking at this issue.
> > 
> > Unfortunately, the kernel still does not work with the applied patch.
> > Neither 32bit nor 64bit kernels boot.  (Note, I applied the patch to
> > Linus' git, and I had to replace mpf->physptr with mpf->mpf_physptr.)
> 
> please add this patch too
> 
> [PATCH] x86: ioremap mptable

Thanks.  Both 32bit and 64bit kernels are working now.

-Kevin
