Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbZGROWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbZGROWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZGROV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:21:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53092 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZGROV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:21:57 -0400
Date: Sat, 18 Jul 2009 16:21:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Andreas Dilger <adilger@sun.com>,
       device-mapper development <dm-devel@redhat.com>,
       Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Message-ID: <20090718142156.GC2682@basil.fritz.box>
References: <19041.4714.686158.130252@notabene.brown> <20090718043155.GI4231@webber.adilger.int> <871voewm6y.fsf@basil.nowhere.org> <20090718065213.GK4231@webber.adilger.int> <20090718074811.GA2682@basil.fritz.box> <20090718134946.GA25546@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090718134946.GA25546@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We don't have to rewrite fsck; most of the framework for supporting an
> run-length-conding for compressed bitmaps is already in patches that
> add > 32-bit block numbers to e2fsprogs; we've just been more focused
> on getting 64-bit block numbers support merged than implementing
> compressed bitmaps, but it's only one file that would need to be
> added, and we might be able to steal the compressed bitmap support
> from xfsprogs --- which does this already.

There are regular reports of xfs_repair failing on 32bit,
even on volumes far smaller than 16TB.
 
-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
