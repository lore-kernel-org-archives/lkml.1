Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbXKFNgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbXKFNgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 08:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXKFNgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 08:36:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55420 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXKFNgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 08:36:01 -0500
Date: Tue, 6 Nov 2007 13:35:59 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, crispin@crispincowan.com
Subject: Re: Problem with accessing namespace_sem from LSM.
Message-ID: <20071106133559.GA13366@infradead.org>
References: <200711060400.lA640fuE078356@www262.sakura.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711060400.lA640fuE078356@www262.sakura.ne.jp>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 01:00:41PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I found that accessing namespace_sem from security_inode_create()
> causes lockdep warning when compiled with CONFIG_PROVE_LOCKING=y .

Any code except VFS internals has no business using it at all and doesn't
do that in mainline either.  I'd start looking for design bugs in whatever
code you have using it first.

