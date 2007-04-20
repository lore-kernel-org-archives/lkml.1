Return-Path: <linux-kernel-owner+w=401wt.eu-S1422888AbXDTFgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422888AbXDTFgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422895AbXDTFgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:36:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422888AbXDTFgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:36:22 -0400
From: Neil Brown <neilb@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Date: Fri, 20 Apr 2007 15:35:56 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17960.20796.761309.771912@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB: kmem_cache_destroy doesn't - version 2.
In-Reply-To: message from Christoph Lameter on Thursday April 19
References: <17960.16739.870487.497750@notabene.brown>
	<Pine.LNX.4.64.0704192215420.16306@schroedinger.engr.sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday April 19, clameter@sgi.com wrote:
> On Fri, 20 Apr 2007, Neil Brown wrote:
> 
> > Not sure how best to fix this one.... kmem_cache_destroy currently
> > doesn't know which alias is being destroyed.
> 
> The aliases are there for decorative purposes when running without
> debugging. If one switches on debugging then it matters but then the
> symlinks are not created since there will be no aliases.
> 
> I guess we can ignore the problem?

Maybe....
But then if we create the same cache with a different size, we might
need to create a directory in sysfs, but there is already a symlink
there... 
It doesn't feel very clean.

NeilBrown
