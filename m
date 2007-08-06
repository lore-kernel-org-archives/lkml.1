Return-Path: <linux-kernel-owner+w=401wt.eu-S1765609AbXHFTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765609AbXHFTF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759963AbXHFTFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:05:06 -0400
Received: from pat.uio.no ([129.240.10.15]:40285 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962AbXHFTFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:05:02 -0400
Subject: Re: [fuse-devel] [PATCH 01/25] VFS: move attr_kill logic from
	notify_change into helper function
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jlayton@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu,
       cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
       mikulas@artax.karlin.mff.cuni.cz, zippel@linux-m68k.org,
       xfs@oss.sgi.com, joel.becker@oracle.com, wli@holomorphy.com,
       reiserfs-devel@vger.kernel.org, dhowells@redhat.com,
       fuse-devel@lists.sourceforge.net, jffs-dev@axis.com,
       user-mode-linux-user@lists.sourceforge.net,
       v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org,
       linux-cifs-client@lists.samba.org, ocfs2-devel@oss.oracle.com,
       bfennema@falcon.csc.calpoly.edu
In-Reply-To: <E1II7JR-0005BN-00@dorka.pomaz.szeredi.hu>
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	 <E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
	 <20070806141333.0f54ab17.jlayton@redhat.com>
	 <E1II7JR-0005BN-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 15:04:23 -0400
Message-Id: <1186427063.6616.59.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.072)
X-UiO-Scanned: E871CF2CF44222422B0CA0EBF571F169B732228E
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 71 total 3121728 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 20:28 +0200, Miklos Szeredi wrote:

> Your patch is changing the API in a very unsafe way, since there will
> be no error or warning on an unconverted fs.  And that could lead to
> security holes.
> 
> If we would rename the setattr method to setattr_new as well as
> changing it's behavior, that would be fine.  But I guess we do not
> want to do that.

Which "unconverted fses"? If we're talking out of tree stuff, then too
bad: it is _their_ responsibility to keep up with kernel changes.

Trond

