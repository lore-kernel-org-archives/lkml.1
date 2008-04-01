Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbYDANjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbYDANjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 09:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbYDANjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 09:39:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22092 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbYDANjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 09:39:40 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [ANNOUNCE] Btrfs v0.13
Date: Tue, 1 Apr 2008 09:38:26 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
References: <200802211609.50563.chris.mason@oracle.com> <20080331224710.GC2362@ldl.fc.hp.com> <20080401004053.GF2362@ldl.fc.hp.com>
In-Reply-To: <20080401004053.GF2362@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804010938.26762.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 March 2008, Alex Chiang wrote:

> > So, using the patch from my last mail, I created a btrfs, but was
> > unable to mount it...
>
> At some point, I got confused which btrfs trees I was working in,
> and gotten switched up to where I had insmod'ed btrfs v0.13, but
> was trying to mount a filesystem created with
> btrfs-progs-unstable. Of course, I got a version mismatch when it
> went to check for BTRFS_MAGIC and mount failed.
>
> Moving to btrfs-unstable allowed me to mount the filesystem.

This is a very easy mistake to make, a long standing TODO is to make sane 
format revision fields.  I'll include this in the multi-device code.  Thanks 
for all the patches so far.

-chris
