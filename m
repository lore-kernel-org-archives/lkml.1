Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYJPCNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYJPCNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 22:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYJPCNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 22:13:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:35831 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbYJPCNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 22:13:37 -0400
Message-ID: <48F6A2E7.5090005@kernel.org>
Date: Thu, 16 Oct 2008 11:11:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, jeff@redhat.com, linux-ide@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stop gcc warning about uninitialized 'dev' in	ata_scsi_scan_host
References: <20081015232505.GB9272@ldl.fc.hp.com>
In-Reply-To: <20081015232505.GB9272@ldl.fc.hp.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Oct 2008 02:13:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Shuts up gcc-3.4.5-glibc-2.3.6 when it complains of:
> 
> drivers/ata/libata-scsi.c: In function `ata_scsi_scan_host':
> drivers/ata/libata-scsi.c:3225: warning: 'dev' might be used
> uninitialized in this function
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>

Nacked-by: Tejun Heo <tj@kernel.org>

Some gcc versions complain about sata_via, others complain about
something else.  Some versions complain about some iterator usages while
not complaining about others, but none of those complaints is actually
wrong or dangerous.  I don't think adding = NULL whenever some version
of gcc complains is the right approach.

Thanks.

-- 
tejun
