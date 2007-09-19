Return-Path: <linux-kernel-owner+w=401wt.eu-S1762248AbXISRyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762248AbXISRyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXISRyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:54:31 -0400
Received: from pat.uio.no ([129.240.10.15]:45947 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbXISRya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:54:30 -0400
Subject: Re: [PATCH 03/24] create cleanup helper svc_msnfs()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <1190223930.26982.109.camel@localhost>
References: <20070917182718.70494C9B@kernel>
	 <20070917182721.8EF73A09@kernel>
	 <Pine.LNX.4.64.0709191939080.10201@fbirervta.pbzchgretzou.qr>
	 <1190223930.26982.109.camel@localhost>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 13:54:06 -0400
Message-Id: <1190224446.6734.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 1C4C6214B127D90F7FE3967796E9205A9221E02C
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1252 total 3988653 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 10:45 -0700, Dave Hansen wrote:
> On Wed, 2007-09-19 at 19:39 +0200, Jan Engelhardt wrote:
> > 
> > >+static inline int svc_msnfs(struct svc_fh *ffhp)
> > >+{
> > >+#ifdef MSNFS
> > >+      return (ffhp->fh_export->ex_flags & NFSEXP_MSNFS);
> > >+#else
> > >+      return 0;
> > >+#endif
> > >+}
> > 
> > The name looks kinda confusing. msnfs? almost makes you think
> > what's got microsoft to do with it.. 
> 
> I'd give it a better name if I had any idea what it means. :)
> 
> The macros and names are all preexisting.  I just took the liberty of
> pulling the #ifdef out into a function because the code got very
> unreadable with the other modifications that I need.
> 
> If it were some kind of larger API, we could come up with something
> better.  But, for a single isolated user, I think it is OK.

The msnfs option means enable the use of MS Windows share locks, so yes,
the name is appropriate.

Trond

