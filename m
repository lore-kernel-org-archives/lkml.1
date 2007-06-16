Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbXFPQOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbXFPQOI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 12:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbXFPQN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 12:13:56 -0400
Received: from [212.112.238.170] ([212.112.238.170]:56957 "EHLO
	longford.lazybastard.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbXFPQN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 12:13:56 -0400
Date: Sat, 16 Jun 2007 16:53:37 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: alan <alan@clueserver.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070616145337.GA13391@lazybastard.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 June 2007 15:51:07 -0700, alan wrote:
> 
> >Thus, in the end it turns out that this stuff is better handled by
> >explicit version-control systems (which require explicit operations to
> >manage revisions) and atomic snapshots (for backup.)
> 
> ZFS is the cool new thing in that space.  Too bad the license makes it 
> hard to incorporate it into the kernel.

It may be the coolest, but there are others as well.  Btrfs looks good,
nilfs finally has a cleaner and may be worth a try, logfs will get
snapshots sooner or later.  Heck, even my crusty old cowlinks can be
viewed as snapshots.

If one has spare cycles to waste, working on one of those makes more
sense than implementing file versioning.

Jörn

-- 
"Security vulnerabilities are here to stay."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
