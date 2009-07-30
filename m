Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZG3V6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZG3V6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZG3V6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:58:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46158 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZG3V6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:58:54 -0400
Date: Thu, 30 Jul 2009 17:58:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] Quota fix for 2.6.31-rc4
Message-ID: <20090730215847.GC15780@infradead.org>
References: <20090730154009.GD28556@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090730154009.GD28556@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 05:40:09PM +0200, Jan Kara wrote:
>   Hello Linus,
> 
>   could you please pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-quota-2.6.git for_linus
> 
>   to get:
> 
> Jan Kara (1):
>       quota: Silence lockdep on quota_on

That's a very bad subject.  IF it's really just silencing it with
annotations please write add lockdep annotations.  But this looks more
like a real (even if mostly theoretical) deadlock, so the subject should
mention that.
