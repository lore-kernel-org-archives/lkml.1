Return-Path: <linux-kernel-owner+w=401wt.eu-S964776AbXBZIih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964776AbXBZIih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 03:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964814AbXBZIih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 03:38:37 -0500
Received: from ns2.suse.de ([195.135.220.15]:38821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964776AbXBZIig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 03:38:36 -0500
From: Neil Brown <neilb@suse.de>
To: "Patrick Ale" <patrick.ale@gmail.com>
Date: Mon, 26 Feb 2007 19:37:37 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17890.40017.353353.633027@notabene.brown>
Cc: "Michael-Luke Jones" <jonesml@fastmail.to>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] Sata RAID
In-Reply-To: message from Patrick Ale on Monday February 26
References: <8d158e1f0702240210x71f981a6xf2fe8917dac5e91a@mail.gmail.com>
	<200702241624.17024.bzolnier@gmail.com>
	<6C96CE3D-85F5-479D-BD44-F5DA0AE744FF@fastmail.to>
	<8d158e1f0702240919v33182ca2qc0a15fdd27a3f96a@mail.gmail.com>
	<8d158e1f0702260030l2f3d9f2ar5c662c807f64f7f7@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday February 26, patrick.ale@gmail.com wrote:
> On 2/24/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> > On 2/24/07, Michael-Luke Jones <jonesml@fastmail.to> wrote:
> 
> One more question regarding this, I am aware its not *really* kernel
> related but answering this question now will save yourself a lot of
> bogus emails from me about MD oopses later and all, and I want to
> setup my disks right once and for all and never witness what I
> witnessed last weeks with my ATA disks.
> 
> Would you use MD at all, taking in account the disks come from the
> same batch and all? I hear these things about MD/RAID being pointless
> when you use disks from the same brand/type/batch since they most
> likely will break shortly after eachother.

Well, it the drives break shortly after each other, you lose your data
no matter what is happening.

But if it is just occasional read errors, md/raid handles those quite
well these days, over-writing the bad block with correct data.

Of course write error cause the drive to be kicked from the array, but
a write error on a modern drive means something much worse that a bit
of bad media has happened.

If I wanted raid1/5/6 I would certainly use md no-matter what batch
the drives were from (but maybe I am a tiny bit biased).

NeilBrown
