Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYARJLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYARJLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758575AbYARJLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:11:15 -0500
Received: from koto.vergenet.net ([210.128.90.7]:48801 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758399AbYARJLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:11:11 -0500
Date: Fri, 18 Jan 2008 18:11:09 +0900
From: Simon Horman <horms@verge.net.au>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org
Subject: Re: [PATCH -mm 1/2 -v2] kexec/i386: kexec page table code clean up
	- add arch_kimage
Message-ID: <20080118091108.GD10957@verge.net.au>
References: <1200377146.3505.50.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200377146.3505.50.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:05:46PM +0800, Huang, Ying wrote:
> This patch add an architecture specific struct arch_kimage into struct
> kimage. Three pointers to page table pages used by kexec are added to
> struct arch_kimage. The page tables pages are dynamically allocated in
> machine_kexec_prepare instead of statically from BSS segment. This
> will save up to 20k memory when kexec image is not loaded.

I like this idea a lot.

Acked-by: Simon Horman <horms@verge.net.au>

> Signed-off-by: Huang Ying <ying.huang@intel.com>

-- 
Horms

