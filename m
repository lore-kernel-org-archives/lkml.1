Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbYI0TF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbYI0TF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 15:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYI0TFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 15:05:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35896 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbYI0TFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 15:05:14 -0400
Date: Sat, 27 Sep 2008 13:04:52 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jike Song <albcamus@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com
Subject: Re: Multiple MSI, take 3
Message-ID: <20080927190452.GQ27204@parisc-linux.org>
References: <20080711005719.GO14894@parisc-linux.org> <df9815e70809252230x4eef3e1ep40a02f101cb90a87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9815e70809252230x4eef3e1ep40a02f101cb90a87@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 01:30:11PM +0800, Jike Song wrote:
> On Fri, Jul 11, 2008 at 8:57 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> > Patchset available as a git tree from:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git multiple-msi
> > (multiple-msi-20080710 is this patch set in particular)
> >
> > Patches will be sent in reply to this message.
> 
> Hi Matthew, what's current state of this work? I pulled it into a
> newly created git branch and tried to rebase it upon the latest Linus
> tree, found that there are some merge conflicts.

The status is that I was working on it on the plane home from Plumbers
and didn't quite managed to get it working on x86-32 yet.  This is a
requirement from Ingo before he'll accept the x86-64 implementation.
I was hoping to work on it some more this week, but a combination of
being ill and having other things to work on (including a lot of patch
review) has meant that I have not had time to look at it.

I did start setting up to test again on Friday ... hopefully I'll have
time on Monday.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
