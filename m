Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYAOOAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYAOOAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 09:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYAOOAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 09:00:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbYAOOAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:00:31 -0500
Date: Tue, 15 Jan 2008 08:56:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Horman <horms@verge.net.au>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org
Subject: Re: [PATCH -mm 1/2 -v2] kexec/i386: kexec page table code clean up
	- add arch_kimage
Message-ID: <20080115135657.GB23722@redhat.com>
References: <1200377146.3505.50.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200377146.3505.50.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:05:46PM +0800, Huang, Ying wrote:
> This patch add an architecture specific struct arch_kimage into struct
> kimage. Three pointers to page table pages used by kexec are added to
> struct arch_kimage. The page tables pages are dynamically allocated in
> machine_kexec_prepare instead of statically from BSS segment. This
> will save up to 20k memory when kexec image is not loaded.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 

Looks good to me.

Thanks
Vivek
