Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYJQHBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYJQHBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 03:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYJQHBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 03:01:39 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:4719 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYJQHBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 03:01:39 -0400
Date: Fri, 17 Oct 2008 09:01:09 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org,
       debian-arm@lists.debian.org, xfs@oss.sgi.com
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081017070109.GA30726@deprecation.cyrius.com>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F7BC9F.4080909@sandeen.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Sandeen <sandeen@sandeen.net> [2008-10-16 17:13]:
> So is this a regression?  did it used to work?  If so, when? :)

The original report was with 2.6.18 but that was with the old ABI:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=423562
I just installed a 2.6.22 kernel with EABI and I can also trigger
the bug.  So it's not a (recent) regression.

> What's a little odd is that the buffer it dumped out looks like the
> beginning of a perfectly valid superblock for your filesystem
> (magic, block size, and block count all match).   If you printk the
> "bno" variable right around line 2106 in xfs_da_btree.c, can you see
> what you get?

bno is 0.

> creating an xfs_metadump of the filesystem for examination on a
> non-arm box might also be interesting.

http://www.cyrius.com/tmp/dump5
(11 MB)
-- 
Martin Michlmayr
http://www.cyrius.com/
