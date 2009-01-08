Return-Path: <linux-kernel-owner+w=401wt.eu-S1762718AbZAHUPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762718AbZAHUPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762696AbZAHUPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:15:10 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:48776 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762190AbZAHUPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:15:06 -0500
Message-ID: <49665EC5.2090707@hp.com>
Date: Thu, 08 Jan 2009 15:15:01 -0500
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Ryusuke Konishi <ryusuke@osrg.net>
Subject: Re: Btrfs for mainline
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1231270893.4888.19.camel@think.oraclecorp.com>
In-Reply-To: <1231270893.4888.19.camel@think.oraclecorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> 
> Unresolved from this reviewing thread:
> 
> * Should it be named btrfsdev?  My vote is no, it is extra work for the
> distros when we finally do rename it, and I don't think btrfs really has
> the reputation for stability right now.  But if Linus or Andrew would
> prefer the dev on there, I'll do it.

We know who has the last word on this.

This is just additional background for those who commented.

Using tricks such as btrfsdev, mount "unsafe", or kernel
messages won't provide a guarantee that btrfs is only used
in appropriate and risk-free ways.  Those tricks also won't
prevent all problems caused by booting a broken old (or new)
release.  And the perceived quality and performance of any
filesystem release, even between stable versions, depends
very much on individual system configuration and use.

Before Chris posted the code, we had some btrfs concall
discussions about the best way to set user expectations on
btrfs mainline 1.0.  Consensus was that the best way we
could do this was to warn them when they did mkfs.btrfs.

Today I sent a patch to Chris (which he may ignore/change)
so mkfs.btrfs will say:

WARNING! - Btrfs v0.16-39-gf9972b4 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

with a blank line before and after.  They don't have to
confirm since they can just mkfs a different filesystem
if I scared them away.  The version is auto-generated.

jim
