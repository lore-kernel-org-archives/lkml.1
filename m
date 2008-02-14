Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYBNQ1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYBNQ1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYBNQ1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:27:15 -0500
Received: from pat.uio.no ([129.240.10.15]:56475 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbYBNQ1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:27:13 -0500
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: menage@google.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <E1JPgYm-0002dm-IX@pomaz-ex.szeredi.hu>
References: <47B283EB.8070209@google.com>
	 <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
	 <6599ad830802140719l270d6fdfyd6d17806eda12a8d@mail.gmail.com>
	 <E1JPgYm-0002dm-IX@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 11:26:59 -0500
Message-Id: <1203006419.8343.48.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 6726A51FA5AFCC3F5BBD297C1E057B06DC2243FC
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 467 total 6887624 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-14 at 17:03 +0100, Miklos Szeredi wrote:

> And I'm not against doing it with the "at*" variants, as Trond
> suggested.

If you're going to change the syscall, then you should ensure that it
solves _all_ the problems that are known at this time. Ignoring the
automounter issue is just going to force us to redo the syscall in a
couple of months...

Trond

