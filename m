Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZCECuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZCECuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 21:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZCECuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 21:50:04 -0500
Received: from ns.suse.de ([195.135.220.2]:59727 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbZCECuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 21:50:03 -0500
From: Neil Brown <neilb@suse.de>
To: Christoph Hellwig <hch@lst.de>
Date: Thu, 5 Mar 2009 13:49:56 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18863.15828.150450.275712@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Future of md multipath
In-Reply-To: message from Christoph Hellwig on Tuesday March 3
References: <20090303180433.GA27569@lst.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday March 3, hch@lst.de wrote:
> Just noticed that we still have the old md-based multipath driver
> in the tree, which seem to not have gotten any attention since we
> got dm multipath.
> 
> Is there any reason to keep it or should we deprecate it and kill
> it after a couple of kernel releases?

I'm in favour of deprecating it.  Whenever I hear of people using it I
suggest dm-multipath, but there could people I don't here about.
I think the upcoming mdadm-3.0 will need a compile-time option to
enable multipath, so people will only get it if they really really
want it.

So feel free to propose patches.

Thanks :-)

NeilBrown
