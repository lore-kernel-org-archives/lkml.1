Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZBXPmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZBXPmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZBXPmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:42:39 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:46379 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbZBXPmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:42:39 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: New filesystem for Linux kernel 
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: Theodore Tso <tytso@mit.edu>, Tomas M <tomas@slax.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1235488695.15148.49.camel@moss-terrapins.epoch.ncsc.mil>
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <20090224141548.GB5482@mit.edu> <1235488695.15148.49.camel@moss-terrapins.epoch.ncsc.mil>
Date: Wed, 25 Feb 2009 00:41:28 +0900
Message-ID: <14799.1235490088@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,
I'm glad if you remember me still.

"David P. Quigley":
> In reality though the debate isn't Unionfs vs AUFS2 because many of the
> kernel people including Christoph have voiced their opinion that they
> don't want to see a file system solution to union mounts. There have
> been patch sets trying to introduce union mounts and they seem to have
> gone quiet for a while as one of the main points of debate was how and
> where to do duplicate elimination.

As I wrote in aufs2 documents, UnionMount may eliminate some
duplication, but it won't be able to share branches.
----------------------------------------------------------------------
UnionMount's approach will be able to small, but may be hard to share
branches between several UnionMount since the whiteout in it is
implemented in the inode on branch filesystem and always
shared. According to Bharata's post, readdir does not seems to be
finished yet.
----------------------------------------------------------------------

Anyway, "kernel people including Christoph have voiced their opinion
that they don't want to see a file system solution to union mounts" is
very impotant. If it is true, I should ask its reason fist. Could you
tell me the source of this information? Url of mail archive or somthing?


> As far as review of AUFS2 goes I use to idle in a few freenode channels
> a while back and there was a discussion about AUFS2 the first time it
> hit LKML. The AUFS people tout that the unionfs dev team has
> incorporated some of their ideas into unionfs and that is true. However,
> one of the issues raised about AUFS back then was that they had all
> sorts of sorted hacks that were unacceptable for use in mainline. I

I am afraid you are confusing aufs1 and aufs2.
And I hope that such "unacceptable" things are dropped from aufs2.


> don't have my irc logs since I am at work and they are at home but I can
> try to dig up the specific problems when I get home later today.

Ok, I'll wait.


J. R. Okajima
