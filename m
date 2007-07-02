Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbXGBBYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbXGBBYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 21:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXGBBYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 21:24:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58265 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750919AbXGBBYK (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 21:24:10 -0400
Message-ID: <468853AD.9070006@sgi.com>
Date: Mon, 02 Jul 2007 11:23:57 +1000
From: Timothy Shimmin <tes@sgi.com>
User-Agent: Thunderbird 2.0.0.4 (Macintosh/20070604)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com
CC: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [xfs-masters] Re: [PATCH][XFS][resend] fix memory leak in xfs_inactive()
References: <200707010116.52012.jesper.juhl@gmail.com> <20070701223147.GU31489@sgi.com>
In-Reply-To: <20070701223147.GU31489@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Sun, Jul 01, 2007 at 01:16:51AM +0200, Jesper Juhl wrote:
>> (this is back from May 16 2007, resending since it doesn't look like 
>> the patch ever made it in anywhere)
> 
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/xfs/xfs_vnodeops.c.diff?r1=1.698;r2=1.699;f=h
> 
> Will get merged in 2.6.23-rc1 window.
> 
> Cheers,
> 
> Dave.

Also, in our master branch of oss git tree (used by Andrew)..
git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git master

commit 1ccb0a872f9cb5056b534fc80c746a68154e08c0
Author: Jesper Juhl <jesper.juhl@gmail.com>
Date:   Thu Jun 28 16:43:14 2007 +1000

     [XFS] Cancel transactions on xfs_itruncate_start error.

     SGI-PV: 966502
     SGI-Modid: xfs-linux-melb:xfs-kern:28943a

     Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>

--Tim

