Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbZADX65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbZADX65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZADX6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:58:38 -0500
Received: from thunk.org ([69.25.196.29]:41526 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbZADX6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:58:36 -0500
Date: Sun, 4 Jan 2009 18:58:27 -0500
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@suse.cz>
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: document ext3 requirements
Message-ID: <20090104235827.GH22958@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Machek <pavel@suse.cz>,
	"Alexander E. Patrakov" <patrakov@gmail.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090103123813.GA1512@ucw.cz> <4960BB2D.3060000@gmail.com> <20090104183834.GB17558@mit.edu> <20090104223756.GD1913@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104223756.GD1913@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 11:37:56PM +0100, Pavel Machek wrote:
> 
> Are you sure you need to have thrashing? AFAICT metadata + fsync heavy
> workload should be enough... and there were scripts to easily repeat
> that.

The memory pressure is needed to force disk buffers out to disk sooner
than fsync() would normally force buffers out.  The scripts which I've
seen induced memory pressure.  If the disk is *super* aggressive at
reordering writes, I suppose a heavy fsync workload might be enough on
its own, but in practice, it's generally not enough.

							- Ted
