Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbZIXOO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbZIXOO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZIXOO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:14:57 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59064 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbZIXOO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:14:57 -0400
Date: Thu, 24 Sep 2009 16:15:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] cciss: fix build when !PROC_FS
Message-ID: <20090924141500.GI23126@kernel.dk>
References: <1253799439-7206-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253799439-7206-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24 2009, Alexander Beregalov wrote:
> Fix these build errors when CONFIG_PROC_FS is not set:
> drivers/block/cciss.c: In function 'cciss_show_raid_level':
> drivers/block/cciss.c:623: error: 'RAID_UNKNOWN' undeclared (first use in this function)
> drivers/block/cciss.c:626: error: 'raid_label' undeclared (first use in this function)
> drivers/block/cciss.c: In function 'cciss_geometry_inquiry':
> drivers/block/cciss.c:2696: error: 'RAID_UNKNOWN' undeclared (first use in this function)

Thanks, applied.

-- 
Jens Axboe

