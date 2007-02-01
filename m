Return-Path: <linux-kernel-owner+w=401wt.eu-S1422646AbXBAXCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422646AbXBAXCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 18:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422696AbXBAXCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 18:02:51 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:36204 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422646AbXBAXCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 18:02:50 -0500
Date: Thu, 1 Feb 2007 15:02:39 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andrew Morton <akpm@osdl.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
In-Reply-To: <20070201202646.GR10305@kernel.dk>
Message-ID: <Pine.LNX.4.64.0702011435060.4632@schroedinger.engr.sgi.com>
References: <20070129204528.eb8d695e.akpm@osdl.org>
 <Pine.LNX.4.64.0701311559310.11853@schroedinger.engr.sgi.com>
 <20070131162422.6bccc52c.akpm@osdl.org> <Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com>
 <20070131163638.290f40c1.akpm@osdl.org> <20070201062018.GC33919298@melbourne.sgi.com>
 <20070131231253.fdebc9f5.akpm@osdl.org> <Pine.LNX.4.64.0702011055310.7010@schroedinger.engr.sgi.com>
 <20070201191857.GQ10305@kernel.dk> <Pine.LNX.4.64.0702011214230.10061@schroedinger.engr.sgi.com>
 <20070201202646.GR10305@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007, Jens Axboe wrote:

> That looks like barriers, could you try with those disabled? Sorry for
> making you go through this, I can't debug and fix it myself before
> monday.

Disabling barriers + your patch works. Modified /etc/fstab and added a 
nobarrier option to the root filesystem. If I take your patch out then the 
systems hangs again.



