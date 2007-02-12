Return-Path: <linux-kernel-owner+w=401wt.eu-S932990AbXBLPk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990AbXBLPk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933000AbXBLPk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:40:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932990AbXBLPk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:40:26 -0500
Date: Mon, 12 Feb 2007 10:40:10 -0500
From: Dave Jones <davej@redhat.com>
To: Valerie Henson <val_henson@linux.intel.com>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>, val_henson@linux.interl.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documenting MS_RELATIME
Message-ID: <20070212154010.GC7617@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Valerie Henson <val_henson@linux.intel.com>,
	Michael Kerrisk <mtk-manpages@gmx.net>, val_henson@linux.interl.com,
	lkml <linux-kernel@vger.kernel.org>
References: <45CE0737.6010103@gmx.net> <20070211005400.GC6849@redhat.com> <20070212065503.GC20919@nifty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212065503.GC20919@nifty>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 10:55:04PM -0800, Valerie Henson wrote:
 > On Sat, Feb 10, 2007 at 07:54:00PM -0500, Dave Jones wrote:
 > > 
 > > Whilst on the subject of RELATIME, is there any good reason why
 > > not to make this a default mount option ?
 > 
 > Ubuntu has been shipping with noatime as the default for some time
 > now, with no obvious problems (I'm running Ubuntu).  I see relatime as
 > an improvement on noatime.

The one problem with noatime is that mutt's 'new mail arrived' breaks
as you mentioned in the relatime changelog, so I'm surprised that
they turned it on by default.  With relatime fixing that however,
I'm also unaware of anything that breaks.   I'd be curious to
do a Fedora test release with relatime, but I know the answer I'll
get when I recommend we add it to our generated fstabs..

"If it's good enough, why isn't it the kernel default"

Hence my current line of questioning ;-)

		Dave

-- 
http://www.codemonkey.org.uk
