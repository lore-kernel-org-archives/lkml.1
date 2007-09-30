Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbXI3RTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbXI3RTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbXI3RTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:19:39 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:47457 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755866AbXI3RTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:19:38 -0400
X-YMail-OSG: 2_7KHT4VM1mGiOYKJTgHcQg4Se.dXRMS7Sl7AyYbs4v2pVhP_LtHoUn0ivddXMo48YBwMeTS3wmOrat4IRj56QCWWUh28.RSd0GLME0Wkov0fwKP8vE-
X-RocketYMMF: rancidfat
Date: Sun, 30 Sep 2007 10:19:36 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: casey@schaufler-ca.com, torvalds@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, James Morris <jmorris@namei.org>,
       Paul Moore <paul.moore@hp.com>
In-Reply-To: <20070930095310.GA18642@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <863863.71085.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Sep 30, 2007 at 01:16:18AM -0700, Andrew Morton wrote:
> > reviewed the August thread from your version 1 submission and the message I
> > take away is that the code has been well-received and looks good when
> > considered on its own merits, but selinux could probably be configured to
> > do something sufficiently similar.
> > 
> > I'd have trouble declaring that "but" to be a reason to not merge smack.
> > I'm more thinking "let's merge it and see if people use it".
> 
> I'm not sure this was discussed on the list, but as long as Casey doesn't
> get rid of the magic symlinks (smackfs_follow_link), there's a clear NACK
> from the VFS perspective.

OK, this is news to me. What's the objection?

> Otherwise the code looks pretty well written, alhough a run through
> checkpath.pl to fix the lose end might help.  Oh, and please to compile-time
> initializations for the spinlocks and mutex currently initializes in
> smack_init.  Also the -Inet/netlabel looks rather odd, please work with
> the netlabel maintainer to move the required files to the include/
> hierachy.

Paul and I discussed this earlier, and will again.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
