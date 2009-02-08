Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbZBHI5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbZBHI5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 03:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZBHI5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 03:57:37 -0500
Received: from verein.lst.de ([213.95.11.210]:51048 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbZBHI5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 03:57:36 -0500
Date: Sun, 8 Feb 2009 09:56:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/4] Rename struct file->f_ep_lock
Message-ID: <20090208085614.GA18521@lst.de>
References: <1234037217-16124-1-git-send-email-corbet@lwn.net> <1234037217-16124-2-git-send-email-corbet@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234037217-16124-2-git-send-email-corbet@lwn.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 01:06:54PM -0700, Jonathan Corbet wrote:
> This lock moves out of the CONFIG_EPOLL ifdef and becomes f_lock.  For now,
> epoll remains the only user, but a future patch will use it to protect
> f_flags as well.

Looks good to me.


Reviewed-by: Christoph Hellwig <hch@lst.de>
