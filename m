Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbZKYLp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbZKYLp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbZKYLp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:45:27 -0500
Received: from thunk.org ([69.25.196.29]:43786 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758641AbZKYLp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:45:26 -0500
Date: Wed, 25 Nov 2009 06:45:22 -0500
From: tytso@mit.edu
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: linux-next: manual merge of the trivial tree with the ext4 tree
Message-ID: <20091125114522.GD14289@thunk.org>
Mail-Followup-To: tytso@mit.edu, Jiri Kosina <jkosina@suse.cz>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
References: <20091125183414.eb45acca.sfr@canb.auug.org.au>
 <alpine.LSU.2.00.0911251216270.6953@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0911251216270.6953@wotan.suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 12:16:43PM +0100, Jiri Kosina wrote:
> On Wed, 25 Nov 2009, Stephen Rothwell wrote:
> 
> > Today's linux-next merge of the trivial tree got a conflict in
> > fs/ext4/balloc.c between commit 4433871130f36585fde38e7dd817433296648945
> > ("ext4: fold ext4_free_blocks() and ext4_mb_free_blocks()") from the ext4
> > tree and commit 15dcf8433b514d1dc1b80d87a0798c2db2c37e95 ("tree-wide: fix
> > some typos and punctuation in comments") from the trivial tree.
> > 
> > The former moved the comment fixed by the latter and fixed the typo along
> > the way.
> 
> Dropped the mballoc hunk from my queue, thanks.

You mean balloc hunk, I hope.  (In the commit in question, I moved the
comment from fs/ext4/balloc.c to fs/ext4/mballoc.c.)

						- Ted
