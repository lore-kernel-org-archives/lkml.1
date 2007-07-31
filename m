Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbXGaLuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbXGaLuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 07:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbXGaLu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 07:50:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbXGaLu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 07:50:26 -0400
Subject: Re: regression on HP zx1 platform from ACPI autoload modules
	patches
From: Doug Chapman <doug.chapman@hp.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-ia64@vger.kernel.org, trenn@suse.de
In-Reply-To: <12c511ca0707302212o3702789bt8d597ec53a389e0a@mail.gmail.com>
References: <1185836238.31298.36.camel@deimos.americas.hpqcorp.net>
	 <6bffcb0e0707301607x5484f114q9117007d131f7118@mail.gmail.com>
	 <12c511ca0707302212o3702789bt8d597ec53a389e0a@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 07:50:04 -0400
Message-Id: <1185882604.14987.2.camel@athlon>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-1.fc5.5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 22:12 -0700, Tony Luck wrote:
> > > During bootup it panics with:
> > >
> > > Kernel panic - not syncing: Unable to find SBA IOMMU: Try a generic or DIG kernel
> 
> I think that the fix for this has already gone into Linus's tree (on
> Friday).  Commit SHA1
> for the patch that should fix this is:
> 8c8eb78f673c07b60f31751e1e47ac367c60c6b7
> 
> If latest GIT tree still has this problem, then please let us know.
> 
> -Tony


Tony,

That was part of the commit that _caused_ the regression actually.
Looking at my first mail I realize I dropped one line when I cut+pasted
that first line from the git show on that one.  If you look toward the
bottom of my original mail you will see it except I missed the line:

commit 8c8eb78f673c07b60f31751e1e47ac367c60c6b7

FYI, I did a git pull yesterday just before I hit this issue so I should
have had the latest stuff.

- Doug


