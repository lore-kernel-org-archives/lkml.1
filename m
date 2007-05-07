Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbXEGNMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbXEGNMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933780AbXEGNMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:12:42 -0400
Received: from pat.uio.no ([129.240.10.15]:59378 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933775AbXEGNMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:12:41 -0400
Subject: Re: [-mm patch] fix fs/nfs/nfsroot.c compile error
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Adrian Bunk <bunk@stusta.de>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070507105607.GB4226@stusta.de>
References: <20070505164422.GD8975@stusta.de>
	 <20070505014955.8f3990b5.akpm@linux-foundation.org>
	 <15958.1178534871@redhat.com>  <20070507105607.GB4226@stusta.de>
Content-Type: text/plain
Date: Mon, 07 May 2007 09:12:23 -0400
Message-Id: <1178543543.6158.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.2, required=12.0, autolearn=disabled, AWL=-0.225)
X-UiO-Scanned: 04177DA079D58646E025AD990A6C1BB038405DF0
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -1 maxlevel 200 minaction 2 bait 0 mail/h: 524 total 1557755 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 12:56 +0200, Adrian Bunk wrote:
> On Mon, May 07, 2007 at 11:47:51AM +0100, David Howells wrote:
> > Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > > match_table_t was made "const" and gcc doesn't like "const __initdata":
> > 
> > Hmmm...  My gcc seems quite happy with it.  What gcc are you using?
> 
> 4.1
> 
> > Shouldn't __initdata override const?
> > 
> > > BTW: Why is this change to include/linux/parser.h in the net tree?
> > 
> > Because DaveM picked it up as part of my AFS patches, I guess.
> 
> It might make sense, but it doesn't seem to be in any way AFS specific.

It makes little or no sense to be forcing attributes like 'const' in a
typedef. That is basically stating that it is inconceivable to use
anything else. Clearly not the case here...

Trond

