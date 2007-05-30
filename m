Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbXE3HQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbXE3HQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXE3HPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:15:52 -0400
Received: from brick.kernel.dk ([80.160.20.94]:28917 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbXE3HPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:15:50 -0400
Date: Wed, 30 May 2007 09:15:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH][RFC] security: revalidate rw permissions for sys_splice and  sys_vmsplice
Message-ID: <20070530071500.GU15559@kernel.dk>
References: <Line.LNX.4.64.0705291617260.9955@d.namei>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0705291617260.9955@d.namei>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29 2007, James Morris wrote:
> Revalidate read/write permissions for splice(2) and vmslice(2), in case 
> security policy has changed since the files were opened.

I guess it was inevitably going to happen :-)

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

