Return-Path: <linux-kernel-owner+w=401wt.eu-S936846AbXGMJpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936846AbXGMJpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763058AbXGMJpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:45:03 -0400
Received: from brick.kernel.dk ([80.160.20.94]:14632 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760530AbXGMJpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:45:00 -0400
Date: Fri, 13 Jul 2007 11:44:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] security: revalidate rw permissions for sys_splice and
	sys_vmsplice
Message-ID: <20070713094445.GC5328@kernel.dk>
References: <Line.LNX.4.64.0707121207380.7550@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0707121207380.7550@d.namei>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12 2007, James Morris wrote:
> Revalidate read/write permissions for splice(2) and vmslice(2), in case 
> security policy has changed since the files were opened.
> 
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> Signed-off-by: James Morris <jmorris@namei.org>
> ---
> 
> Updated version against latest Linus git.  Jens, I dropped your initial 
> signed-off-by due to the rework.
> 
> Please review and apply if ok.

No worries, re-signed and applied!

-- 
Jens Axboe

