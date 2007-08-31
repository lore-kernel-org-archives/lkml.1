Return-Path: <linux-kernel-owner+w=401wt.eu-S966116AbXHaTNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966116AbXHaTNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 15:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932850AbXHaTNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 15:13:31 -0400
Received: from pat.uio.no ([129.240.10.15]:33629 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661AbXHaTNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 15:13:31 -0400
Subject: RE: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Frank van Maarseveen'" <frankvm@frankvm.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <006a01c7ebff$709354c0$51b9fe40$@com>
References: <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
	 <1188577275.6649.133.camel@heimdal.trondhjem.org>
	 <006a01c7ebff$709354c0$51b9fe40$@com>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 15:13:21 -0400
Message-Id: <1188587601.19730.45.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.080)
X-UiO-Scanned: D5A366D32EB492DB34BC6AACB64BCDDE12265DAA
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 127 total 3593821 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 11:47 -0700, Hua Zhong wrote:
> This patch fixes the problem for me, thanks.
> 
> Is this patch changing the behavior of "sharecache" to
> "try-to-share-cache-if-possible", or adding a third behavior? If the user
> explicitly asks for "-o sharecache", does he get an error back if the mount
> options mismatch?

There has never been a 'sharecache' flag as far as the kernel is
concerned. The default behaviour has always been to share.

Trond


