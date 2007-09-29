Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbXI2V7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbXI2V7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 17:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXI2V7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 17:59:41 -0400
Received: from pat.uio.no ([129.240.10.15]:38704 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbXI2V7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 17:59:41 -0400
Subject: Re: FW: [patch 01/02] vfs: variant symlinks
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Schmidt, Kenneth P" <kenneth.schmidt@pnl.gov>
Cc: Jan Dittmer <jdi@l4x.org>, Al Viro <viro@ftp.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <C323F837.4E04%kenneth.schmidt@pnl.gov>
References: <C323F837.4E04%kenneth.schmidt@pnl.gov>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 17:59:25 -0400
Message-Id: <1191103165.6655.8.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.120)
X-UiO-Scanned: B1F777BA3480AA04993EB8C65EF7EC871C09EE1D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 232 total 4189043 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-29 at 12:40 -0700, Schmidt, Kenneth P wrote:

> The best example of how this can be useful is to allow a heterogeneous
> environment which uses a common filesystem. For example, both x86_64 and
> power systems could mount a root nfs share and execute with a common set of
> configurations and data, but the binary directories (bin and lib) could
> point to architecture specific directories.

That would hardly be a portable NFS environment. Boot a Solaris, or
older Linux kernel, and watch your applications barf...

This sort of stuff belongs in the automounter, not the kernel.

Trond

