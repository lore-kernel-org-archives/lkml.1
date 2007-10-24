Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbXJXBUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbXJXBUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbXJXBUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:20:36 -0400
Received: from pat.uio.no ([129.240.10.15]:53908 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbXJXBUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:20:35 -0400
Subject: Re: LTP ustat01 test fails on NFSROOT
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nfs@lists.sourceforge.net, neilb@suse.de, bfields@fieldses.org,
       chuck.lever@oracle.com
In-Reply-To: <CBDE987B-0713-4D62-8122-054183E75410@kernel.crashing.org>
References: <CBDE987B-0713-4D62-8122-054183E75410@kernel.crashing.org>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 21:21:34 -0400
Message-Id: <1193188894.27073.20.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.140)
X-UiO-Scanned: 45F1D2C1790F860F827DD428DBBDEC78001AEC0A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 99 total 4677361 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-23 at 17:52 -0500, Kumar Gala wrote:
> I'm looking into an issue with LTP's ustat01 & ustat02 tests in which  
> they report the following:
> 
> ustat01     1  FAIL  :  ustat(2) failed and setthe errno to 116 :  
> Stale NFS file handle
> ustat02     2  FAIL  :  ustat(2) failed to produce expected error;  
> 14, errno: EFAULT and got 116
> 
> It appears sometime between 2.6.21 and 2.6.22-rc1 some changes to NFS  
> got introduced that cause this.
> 
> was wondering about any ideas while I try to debug what's going on.
> 
> thanks
> 
> - k

I'm seeing zero problems with the latest checkouts from Linus' git tree.
Mind giving us some more details?

'strace' output would be useful, as would the standard NFS list of
client mount options, server export options, details on how your
exported partition is set up on the server, etc...

Trond

