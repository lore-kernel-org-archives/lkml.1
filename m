Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935Ab0AEVj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab0AEVj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885Ab0AEVj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:39:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:42987 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab0AEVj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:39:27 -0500
Date: Tue, 5 Jan 2010 22:39:27 +0100
From: Jan Kara <jack@suse.cz>
To: Greg KH <gregkh@suse.de>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 83/97] ext4: Fix potential quota deadlock
Message-ID: <20100105213927.GA3252@quack.suse.cz>
References: <20100105003133.GA7199@kroah.com>
 <1262651630-7354-83-git-send-email-gregkh@suse.de>
 <20100105004741.GD3252@quack.suse.cz>
 <20100105185655.GB15630@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105185655.GB15630@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 05-01-10 10:56:55, Greg KH wrote:
> On Tue, Jan 05, 2010 at 01:47:42AM +0100, Jan Kara wrote:
> > On Mon 04-01-10 16:33:36, Greg Kroah-Hartman wrote:
> > > From: Dmitry Monakhov <dmonakhov@openvz.org>
> > > 
> > > commit d21cd8f163ac44b15c465aab7306db931c606908 upstream.
> >   Ted has found a serious bug in this patch over Christmas and fixed it.
> > Ted, do you prefer to just discard this patch or will you add your fixes?
> Do you have the git commit id of the patch that fixes it?
  Commits fixing the behavior are:
0637c6f4135f592f094207c7c21e7c0fc5557834
ee5f4d9cdf32fd99172d11665c592a288c2b1ff4
9d0be50230b333005635967f7ecd4897dbfd181b

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
