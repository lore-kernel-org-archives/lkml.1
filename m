Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbYANNak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbYANNak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbYANNab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:30:31 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13118 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbYANNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:30:30 -0500
X-SBRS: None
X-MesageID: 37625939
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,282,1196658000"; 
   d="scan'208";a="37625939"
Subject: Re: [PATCH -mm 1/2] kexec/i386: kexec page table code clean up -
	add arch_kimage
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20080110081535.GA30505@verge.net.au>
References: <1199847467.8126.15.camel@caritas-dev.intel.com>
	 <20080110011423.GB23143@redhat.com>  <20080110081535.GA30505@verge.net.au>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Mon, 14 Jan 2008 13:29:36 +0000
Message-Id: <1200317376.11020.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 17:15 +0900, Simon Horman wrote: 
> > Have you tested Xen too? Does it run into issues with this change?
> 
> Xen will need to be updated for this change but it shouldn't be a big
> deal. Basically right now it calls __ma() (which is kind of like __pa())
> on kexec_pgd and friends. Updating the arguments to __ma() to use
> the new arch_kimage pointers should be easy enough.

I think you mean the Xen specific parts of the kexec machinery in the
kernel.c would need updating rather than the hypervisor, right?

I don't think these changes will cause anything more than minor problems
for whoever ports the Xen kexec stuff upstream.

> N.B: As this is Dom0 code (not DomU) it is maintained in the xen
> repository and has been merged into Linux.

I don't think we would bother backporting these changes to there, would
we?

Ian.


