Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbXGMNQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbXGMNQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758216AbXGMNPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:15:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:49547 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757974AbXGMNPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:15:52 -0400
Date: Fri, 13 Jul 2007 15:15:50 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070713131550.GB10985@suse.de>
Mail-Followup-To: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>,
	Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <20070710120243.GA10121@hmsendeavour.rdu.redhat.com> <20070713200533oomichi@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713200533oomichi@mail.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp> [2007-07-13 13:05]:
> 
> BTW, I'd like to remove PAGESIZE from a mkdfinfo file.
> While 2nd-kernel is running, new makedumpfile comes to consider
> 2nd-kernel PAGESIZE as 1st-kernel PAGESIZE without getting PAGESIZE
> from a mkdfinfo file.

I don't think that's a good idea. IMO the kernel should be modified to
export the page size in a variable for that purpose. That would solve
all problems and dependencies, doesn't it?



Thanks,
   Bernhard
