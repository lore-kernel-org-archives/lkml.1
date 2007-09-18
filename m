Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbXIRN1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbXIRN1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 09:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbXIRN1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 09:27:25 -0400
Received: from pat.uio.no ([129.240.10.15]:54464 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbXIRN1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 09:27:24 -0400
Subject: Re: [PATCH 5/5][NFS] Cleanup explicit check for mandatory locks
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
In-Reply-To: <46EF6E18.90801@openvz.org>
References: <46EE335C.3010106@openvz.org>
	 <1190048620.6700.100.camel@heimdal.trondhjem.org>
	 <46EF6E18.90801@openvz.org>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 09:27:15 -0400
Message-Id: <1190122035.6665.15.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.039)
X-UiO-Scanned: 779B7500E7094487FAFBF26F099A84C4AB7AB190
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 928 total 3949919 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 10:20 +0400, Pavel Emelyanov wrote:
> Trond Myklebust wrote:
> > On Mon, 2007-09-17 at 11:57 +0400, Pavel Emelyanov wrote:
> >> The __mandatory_lock(inode) macro makes the same check, but
> >> makes the code more readable.
> > 
> > Could we please avoid using underscores in macros. Also, why are we
> > breaking the usual convention of capitalising macro names?
> 
> Sorry, I've forgot to change all the log - this is not a macro, 
> but a static inline function. The underscores are here, because 
> the mandatory_lock() one already exists and additionally checks 
> for "if (IS_MANDLOCK(inode))"

OK. I withdraw my objection then.

Cheers
  Trond

