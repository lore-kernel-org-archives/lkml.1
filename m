Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbZGROdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbZGROdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZGROdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:33:38 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:63899 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbZGROdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:33:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Sat, 18 Jul 2009 10:32:19 -0400
From: Andreas Dilger <adilger@sun.com>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
In-reply-to: <20090718142156.GC2682@basil.fritz.box>
To: Andi Kleen <andi@firstfloor.org>
Cc: Theodore Tso <tytso@mit.edu>,
       device-mapper development <dm-devel@redhat.com>,
       Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20090718143219.GL4231@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <19041.4714.686158.130252@notabene.brown>
 <20090718043155.GI4231@webber.adilger.int> <871voewm6y.fsf@basil.nowhere.org>
 <20090718065213.GK4231@webber.adilger.int>
 <20090718074811.GA2682@basil.fritz.box> <20090718134946.GA25546@mit.edu>
 <20090718142156.GC2682@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 18, 2009  16:21 +0200, Andi Kleen wrote:
> > We don't have to rewrite fsck; most of the framework for supporting an
> > run-length-conding for compressed bitmaps is already in patches that
> > add > 32-bit block numbers to e2fsprogs; we've just been more focused
> > on getting 64-bit block numbers support merged than implementing
> > compressed bitmaps, but it's only one file that would need to be
> > added, and we might be able to steal the compressed bitmap support
> > from xfsprogs --- which does this already.
> 
> There are regular reports of xfs_repair failing on 32bit,
> even on volumes far smaller than 16TB.

It's a good thing we have ext4 then :-).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

