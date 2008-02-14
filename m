Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbYBNXd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbYBNXd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759177AbYBNXdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:33:16 -0500
Received: from pat.uio.no ([129.240.10.15]:37273 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758445AbYBNXdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:33:15 -0500
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: menage@google.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <E1JPmPw-0003au-SF@pomaz-ex.szeredi.hu>
References: <47B283EB.8070209@google.com>
	 <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
	 <6599ad830802140719l270d6fdfyd6d17806eda12a8d@mail.gmail.com>
	 <E1JPgYm-0002dm-IX@pomaz-ex.szeredi.hu>
	 <1203006419.8343.48.camel@heimdal.trondhjem.org>
	 <E1JPi3u-0002rp-Nz@pomaz-ex.szeredi.hu>
	 <1203016675.18369.21.camel@heimdal.trondhjem.org>
	 <E1JPmPw-0003au-SF@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 18:33:02 -0500
Message-Id: <1203031982.18860.60.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 8675A07D00B65D33578260243C07B7E53388ED9E
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 182 total 6892124 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-14 at 23:18 +0100, Miklos Szeredi wrote:

> I understand perfectly that this is what you want to do.  And I'm
> saying that the following code snippet should do exactly the same,
> without having to add a new syscall:
> 
> 	char tmpbuf[64];
> 	sprintf(tmpbuf, "/proc/self/fd/%i", fd);
> 	mount(dev_name, tmpbuf, type, flags, data);
> 
> [ You could actually try to read people's responses, instead of
> immediately assuming they don't understand :-/ ]

I did read your reply, but the follow-link magic that is performed in
proc_fd_link() wasn't immediately obvious to someone who is unfamiliar
with that code. I understand where you're coming from now.

Anyhow, that does indeed look as if it will do what is needed for the
automounter.

   Trond

