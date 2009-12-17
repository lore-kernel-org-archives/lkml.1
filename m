Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbZLQBAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbZLQBAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbZLQBAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:00:09 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:54040 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762083AbZLQBAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:00:07 -0500
Date: Thu, 17 Dec 2009 12:00:01 +1100
From: Simon Horman <horms@verge.net.au>
To: Daniel Poelzleithner <poelzi@poelzi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suggestion: xtime as new inode attribute
Message-ID: <20091217010001.GF22449@verge.net.au>
References: <4B292D9A.5060501@poelzi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B292D9A.5060501@poelzi.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 07:57:30PM +0100, Daniel Poelzleithner wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi,
> 
> I would like to suggest a new attribute for inodes in linux filesystems
> to record the last execution time of files.
> 
> The problem:
> 
> If a linux installation gets older and older, more and more programs get
> installed over time. Mostly to just test them for a particular problem
> and often the deinstallation is forgotten. To find out which packages
> are not used for a long time is currently quite impossible. The user may
> use program X which will run but not depend on program Y as a subprocess
> for example.
> 
> The solution:
> 
> I suggest a new inode attribute called xtime, which is like atime, but
> will only be updated when a file is executed. This would allow tracking
> of unused binaries and could be used with some clever algorithms in the
> cleanup program to find unused packages for removal or other cleanup
> purposes.
> It would also add an additional information in forensic analysis of
> hacked systems btw.

Given the existence of noatime and other related mount options
designed to mitigate the performance penalty related to atime,
adding xtime doesn't strike me as a particularly good idea.
I suspect there are easier ways to track when executables are
executed.
