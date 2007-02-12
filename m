Return-Path: <linux-kernel-owner+w=401wt.eu-S965341AbXBLTmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965341AbXBLTmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965343AbXBLTmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:42:21 -0500
Received: from mga06.intel.com ([134.134.136.21]:7359 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965341AbXBLTmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:42:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,316,1167638400"; 
   d="scan'208"; a="195879312:sNHT23248659"
Date: Mon, 12 Feb 2007 11:42:11 -0800
From: Valerie Henson <val_henson@linux.intel.com>
To: Dave Jones <davej@redhat.com>, Michael Kerrisk <mtk-manpages@gmx.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documenting MS_RELATIME
Message-ID: <20070212194211.GA5108@nifty>
References: <45CE0737.6010103@gmx.net> <20070211005400.GC6849@redhat.com> <20070212065503.GC20919@nifty> <20070212154010.GC7617@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212154010.GC7617@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 10:40:10AM -0500, Dave Jones wrote:
> 
> The one problem with noatime is that mutt's 'new mail arrived' breaks
> as you mentioned in the relatime changelog, so I'm surprised that
> they turned it on by default.  With relatime fixing that however,
> I'm also unaware of anything that breaks.   I'd be curious to
> do a Fedora test release with relatime, but I know the answer I'll
> get when I recommend we add it to our generated fstabs..
> 
> "If it's good enough, why isn't it the kernel default"
> 
> Hence my current line of questioning ;-)

Okay, I have to admit I used the normal atime semantics, exactly once.
Someone hacked my laptop about 4 years ago (back when I didn't have a
firewall and a remotely exploitable samba server was on by default in
some Red Hat install).  I pulled the plug on the network (no wireless
either) and figured out which files the attacker read, which gave me
some peace of mind. :)

Personally, I'd trade that for the performance/battery life/etc. of
relatime.

-VAL
