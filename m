Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZFHKZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZFHKZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbZFHKZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:25:08 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43517 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbZFHKZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:25:07 -0400
Date: Mon, 8 Jun 2009 11:24:49 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com,
       tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de,
       akpm@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 0/23] File descriptor hot-unplug support v2
Message-ID: <20090608102449.GB25684@shareable.org>
References: <m1skkf761y.fsf@fess.ebiederm.org> <m1oct739xu.fsf@fess.ebiederm.org> <20090606080334.GA15204@ZenIV.linux.org.uk> <E1MDbLz-0003wm-Db@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1MDbLz-0003wm-Db@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Sat, 6 Jun 2009, Al Viro wrote:
> > Frankly, I very much suspect that force-umount is another case like that;
> > we'll need a *lot* of interesting cooperation from fs for that to work and
> > to be useful.  I'd be delighted to be proven incorrect on that one, so
> > if you have anything serious in that direction, please share the details.
> 
> Umm, not sure why we'd need cooperation from the fs.  Simply wait for
> the operation to exit the filesystem or driver.  If it's a blocking
> operation, send a signal to interrupt it.

We could even include the internal signal in TASK_KILLABLE, so it
interrupts otherwise uninterruptible operations.

-- Jamie
