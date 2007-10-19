Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbXJSNk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbXJSNk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 09:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXJSNkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 09:40:15 -0400
Received: from pat.uio.no ([129.240.10.15]:56855 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758008AbXJSNkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 09:40:14 -0400
Subject: Re: nfsv2 ref leak in 2.6.24?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: bfields@fieldses.org, nfs@lists.sourceforge.net, neilb@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200710190549.l9J5nnX8007119@agora.fsl.cs.sunysb.edu>
References: <200710190549.l9J5nnX8007119@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 09:41:16 -0400
Message-Id: <1192801277.7073.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.073)
X-UiO-Scanned: 620F7FB0A25508721B4F34967D1E9A68F2B759EC
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1168 total 4599944 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-19 at 01:49 -0400, Erez Zadok wrote:
> I'm testing unionfs on top of nfsv2/3/4, using 2.6.24 as of linus's commit
> 4fa4d23fa20de67df919030c1216295664866ad7.  A lot of my unionfs regression
> tests are failing on nfs2, b/c files that should be deleted, aren't.  It
> feels like there may be a ref leak that prevents the files from being
> deleted, or maybe an unlink issue.  It doesn't happen in all of my previous
> kernels w/ identical unionfs (code 2.6.9--2.6.23).  And in 2.6.24 it happens
> only w/ nfs2 -- nfs3/4 are fine.
> 
> I'm not sure if this is a client or server issue, and I'm only starting to
> dig deeper.  But I thought I'd ask you in case this is a known problem and
> you have a fix.  If this is the first you hear of this problem, let me know
> and I'll try to narrow it down further.

A couple of questions:

      * Are these files being sillyrenamed?
      * Are they shown as being removed by the server?

Cheers
  Trond

