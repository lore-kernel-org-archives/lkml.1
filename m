Return-Path: <linux-kernel-owner+w=401wt.eu-S965044AbXHaL5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044AbXHaL5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbXHaL5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:57:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35771 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932765AbXHaL5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:57:15 -0400
Date: Fri, 31 Aug 2007 17:40:00 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rob Landley <rob@landley.net>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation/00-INDEX notice ecryptfs.txt moved.
In-Reply-To: <200708302016.12133.rob@landley.net>
Message-ID: <alpine.LFD.0.999.0708311705270.7173@enigma.security.iitk.ac.in>
References: <200708301446.18024.rob@landley.net> <20070830120437.6fe49cdc.randy.dunlap@oracle.com>
 <200708302016.12133.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,


On Thu, 30 Aug 2007, Rob Landley wrote:

> On Thursday 30 August 2007 2:04:37 pm Randy Dunlap wrote:
> > Please use the expected (canonical) patch format.
> >
> > See Documentation/SubmittingPatches:
> >   14) The canonical patch format
> 
> from Rob Landley <rob@landley.net>
> Signed-off-by: Rob Landley <rob@landley.net>
> 
> ecryptfs.txt moved into filesystems, make 00-INDEX follow.

That's still not quite right :-) What Randy meant is that the sign-off
must come /after/ the patch description:

From: Random J Hacker <random@hacker.com>
/*
 * Above line not really required if it's your own patch that you're
 * sending. But required when you're "relaying" someone else's patch,
 * or if there are multiple people in the sign-off chain below,
 * to differentiate as to who was the author of the patch.
 */

[PATCH] <subsystem>: <one-line summary>
/*
 * Above line not really required if Subject: of email already such.
 * But may be required if you're replying on some other LKML thread,
 * whose subject may have nothing to do with this patch.
 */

<a few line(s) of patch description,

maybe a couple of paragraphs even.>

Signed-off-by: Random J Hacker <random@hacker.com>
Signed-off-by: Bob Z Maintainer <bob@maintainer.com>
/*
 * It is generally preferable to order the sign-off's above so that
 * they reflect the patch journey -- so the original author preferably
 * comes first, then those who relayed it or picked it up from the
 * author (often the maintainer), and so on, till the person who is
 * finally relaying it currently (so from the above it seems this is
 * being sent out by Bob). If this is the first time a patch is being
 * sent, there would naturally be just a single sign-off line.
 */

Then three hyphens, followed by diffstat and patch ... so the below
looks good :-)

[ All this is not too important, admittedly, but causes least amount of
  processing time to be wasted on the recipient's end, and also does not
  confuse scripts that may be used to extract patches (and git commit
  command-line arguments) from mails automatically. ]


> ---
> 
>  00-INDEX             |    2 --
>  filesystems/00-INDEX |    2 ++
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.23-rc4/Documentation/00-INDEX	2007-08-27 20:32:35.000000000 -0500
> +++ linux-new/Documentation/00-INDEX	2007-08-30 14:43:15.000000000 -0500
> @@ -134,8 +134,6 @@
>  	- info on Linux Digital Video Broadcast (DVB) subsystem.
>  early-userspace/
>  	- info about initramfs, klibc, and userspace early during boot.
> -ecryptfs.txt
> -	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
>  eisa.txt
>  	- info on EISA bus support.
>  exception.txt
> --- linux-2.6.23-rc4/Documentation/filesystems/00-INDEX	2007-08-27 20:32:35.000000000 -0500
> +++ linux-new/Documentation/filesystems/00-INDEX	2007-08-30 14:42:08.000000000 -0500
> @@ -32,6 +32,8 @@
>  	- info about the locking scheme used for directory operations.
>  dlmfs.txt
>  	- info on the userspace interface to the OCFS2 DLM.
> +ecryptfs.txt
> +	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
>  ext2.txt
>  	- info, mount options and specifications for the Ext2 filesystem.
>  ext3.txt
