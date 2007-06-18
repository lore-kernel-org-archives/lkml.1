Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbXFRJzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbXFRJzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXFRJzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:55:09 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:46088
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753859AbXFRJzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:55:07 -0400
Message-ID: <4676563D.2010402@hawkeye.stone.uk.eu.org>
Date: Mon, 18 Jun 2007 10:54:05 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Andreas Dilger <adilger@clusterfs.com>
CC: alan <alan@clueserver.org>, hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int>
In-Reply-To: <20070618094524.GF5181@schatzie.adilger.int>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> Too bad everyone is spending time on 10 similar-but-slightly-different
> filesystems.  This will likely end up with a bunch of filesystems that
> implement some easy subset of features, but will not get polished for
> users or have a full set of features implemented (e.g. ACL, quota, fsck,
> etc).  While I don't think there is a single answer to every question,
> it does seem that the number of filesystem projects has climbed lately.
> 
> Maybe there should be a BOF at OLS to merge these filesystem projects
> (btrfs, chunkfs, tilefs, logfs, etc) into a single project with multiple
> people working on getting it solid, scalable (parallel readers/writers on
> lots of CPUs), robust (checksums, failure localization), recoverable, etc.
> I thought Val's FS summits were designed to get developers to collaborate,
> but it seems everyone has gone back to their corners to work on their own
> filesystem?
> 
> Working on getting hooks into DM/MD so that the filesystem and RAID layers
> can move beyond "ignorance is bliss" when talking to each other would be
> great.  Not rebuilding empty parts of the fs, limit parity resync to parts
> of the fs that were in the previous transaction, use fs-supplied checksums
> to verify on-disk data is correct, use RAID geometry when doing allocations,
> etc.

How many of these feature could be (at least partially) implemented in
the core code so that it was easier to port filesystems to use them.
Certainly versioning should be able to be implemented, possible without
any FS support at all, in the core code. Centralising the
implementations could allow a great deal of FS
custiomisation/improvements with very little new per FS code.

Jack
