Return-Path: <linux-kernel-owner+w=401wt.eu-S1030725AbXCLRSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030725AbXCLRSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030730AbXCLRSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:18:05 -0400
Received: from pat.uio.no ([129.240.10.15]:58582 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030725AbXCLRSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:18:02 -0400
Subject: Re: 2.6.20.2: kernel BUG at fs/nfs/write.c:505!
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Dave Jones <davej@redhat.com>
Cc: Stresslinux Kernel <lk@stresslinux.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070312171324.GC22223@redhat.com>
References: <45F5582C.1050100@stresslinux.org>
	 <1173718831.6436.30.camel@heimdal.trondhjem.org>
	 <20070312171324.GC22223@redhat.com>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 13:17:57 -0400
Message-Id: <1173719877.6436.40.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 8BF5C9271328FFD70AF4259DC3A96CA9836D0D73
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 311 total 413559 max/h 7466 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 13:13 -0400, Dave Jones wrote:
> On Mon, Mar 12, 2007 at 01:00:31PM -0400, Trond Myklebust wrote:
> 
>  > > Code: 0f 0b eb fe f0 ff 41 44 c7 85 18 01 00 00 01 00 00 00 48 8b
>  > > RIP  [<ffffffff8032fb83>] nfs_wait_on_requests_locked+0x43/0xb2
>  > >  RSP <ffff81007d669ca8>
>  > 
>  > Known issue. There is already a fix available in the -mm kernel
>  > (attached).
> 
> Did this get sent to -stable too for .20.3 ?

Sorry, no. It is not even in mainline yet. I've been travelling a bit
too much recently.

Cheers
  Trond

