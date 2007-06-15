Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbXFOWiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbXFOWiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbXFOWin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:38:43 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45049 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbXFOWil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:38:41 -0400
Message-ID: <467314E2.9010306@zytor.com>
Date: Fri, 15 Jun 2007 15:38:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org>
In-Reply-To: <46731169.2090002@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Stone wrote:
> I hope I got the CC list right. Apologies to anyone in didn't include
> and anyone I shouldn't have included.
> 
> The basic idea is to include an idea from VMS that seems to be quite
> useful: version numbers for files.
> 
> The idea is that whenever you modify a file the system saves it to na
> new copy leaving the old file intact. This could be a great advantage
> from many view points:
> 	1) it would be much easier to do package management as the old
> 		version would be automatically saved for a package
> 		management system to deal with.
> 
> 	2) backups would also be easier as all versions of a file
> 		are automatically saved so it could be potentially very
> 		useful for a company or the like.
> 

This is one of those things that seems like a good idea, but frequently
ends up short.  Part of the problem is that "whenever you modify a file"
is ill-defined, or rather, if you were to take the literal meaning of it
you'd end up with an unmanageable number of revisions.

Furthermore, it turns out that often relationships between files are
more important.

Thus, in the end it turns out that this stuff is better handled by
explicit version-control systems (which require explicit operations to
manage revisions) and atomic snapshots (for backup.)

	-hpa
