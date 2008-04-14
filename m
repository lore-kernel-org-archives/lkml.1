Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbYDNGUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbYDNGUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 02:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYDNGUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 02:20:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41917 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYDNGT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:19:59 -0400
Date: Mon, 14 Apr 2008 02:19:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] F_GETPATH for linux
Message-ID: <20080414061958.GA21202@infradead.org>
References: <Pine.LNX.4.64.0804131455030.12741@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804131455030.12741@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 03:00:53PM -0700, Davide Libenzi wrote:
> I was working on some bsd/linux compatibility code, and I noticed that we 
> do not have F_GETPATH. I know we can readlink /proc/PID/fd/FD (that is 
> what I'm doing now, under #ifdef), but I gave a patch a shot anyway.
> Here it is, building but untested ...

Adding a duplicated API like this is rather pointless.  Especially as
the readlink is easier and makes more sense.
