Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbXKLJCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbXKLJCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 04:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbXKLJB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 04:01:56 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4908 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbXKLJBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 04:01:55 -0500
Date: Mon, 12 Nov 2007 09:01:54 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Warning: commit message does not conform to UTF-8. (mmotm "10-Nov-2007 22:46")
Message-ID: <20071112090136.GF301@shadowen.org>
References: <200711110030.lAB0UvLx006968@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200711110030.lAB0UvLx006968@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 07:30:57PM -0500, Erez Zadok wrote:
> Andrew,
> 
> I'm getting minor warnings when applying two patches from
> <http://userweb.kernel.org/~akpm/mmotm/>
> 
> It's probably not serious but I wonder if checkpatch catches this.
> 
> Applying patch..git-net.patch
> Warning: commit message does not conform to UTF-8.
> You may want to amend it after fixing the message, or set the config
> variable i18n.commitencoding to the encoding your project uses.
> 
> Applying patch..mnt_unbindable-fix.patch
> Warning: commit message does not conform to UTF-8.
> You may want to amend it after fixing the message, or set the config
> variable i18n.commitencoding to the encoding your project uses.

We do have checks for UTF-8.  The commit message problems are usually real
names in Signed-off-by:s being "complex" and being in their email locale
not UTF-8.  It is a problem area for sure as people want their email to
look right in their email to the list, and yet they need it in UTF-8 for git.

Yeah it looks like we pick it up ok, the message could do with a little
love:

    apw@pinky$ ~/git/checkpatch/checkpatch.pl -q --no-tree ./git-net.patch
    ERROR: Invalid UTF-8
    #229:
	This is based on a patch by Vicenç Beltran Querol.

    ERROR: Invalid UTF-8
    #398:
	by Toralf Förster:

    ERROR: Invalid UTF-8
    #773:
	Signed-off-by: Lutz Preßler <Lutz.Pressler@SerNet.DE>

-apw
