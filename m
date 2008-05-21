Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbYEUT0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbYEUT0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbYEUT03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:26:29 -0400
Received: from pat.uio.no ([129.240.10.15]:55249 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbYEUT02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:26:28 -0400
Subject: Re: [patch 11/14] vfs: move executable checking into ->permission()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1Jytgu-00068N-Tp@pomaz-ex.szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
	 <20080521171557.399850407@szeredi.hu> <1211393793.7486.15.camel@localhost>
	 <E1Jytgu-00068N-Tp@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Wed, 21 May 2008 15:26:24 -0400
Message-Id: <1211397984.7486.38.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5)
X-UiO-Scanned: 8EF9EBAC19264E6B19C07020046A4BC0F7D8BE94
X-UiO-SR-test: 9872C9EB5EB894D5EB613C9C5AA76B28699D569D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 332 total 8521019 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 21:09 +0200, Miklos Szeredi wrote:

> No, we don't want to deny read or write (that's up to the filesystem
> how it handles it), just want to deny execute if no x bits are set in
> the mode.

OK, but when I see something with the name 'exec_permission()', I assume
that it is going to check for whether or not I have execute permission.

If that is not the case, then can we please either change the function,
or change the name?

Cheers
  Trond

