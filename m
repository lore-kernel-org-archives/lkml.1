Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZK2JKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZK2JKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 04:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZK2JKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 04:10:32 -0500
Received: from daytona.panasas.com ([67.152.220.89]:39927 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753316AbZK2JKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 04:10:24 -0500
Message-ID: <4B123A82.10104@panasas.com>
Date: Sun, 29 Nov 2009 11:10:26 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Remi/fc10 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: manual merge of the osd tree with the scsi tree
References: <20091127143229.108298c6.sfr@canb.auug.org.au>
In-Reply-To: <20091127143229.108298c6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2009 09:10:29.0669 (UTC) FILETIME=[CC03C550:01CA70D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2009 05:32 AM, Stephen Rothwell wrote:
> Hi Boaz,
> 
> Today's linux-next merge of the osd tree got a conflict in
> drivers/scsi/osd/osd_uld.c between commit
> f89b9ee4a722721ed205b8c29555ac75fbe8c2cc ("[SCSI] osduld: Use
> device->release instead of internal kref") from the scsi tree and commit
> 9b579fe8588b861dcf0c9b620757729643db4557 ("osduld: Use device->release
> instead of internal kref") from the osd tree.
> 
> These are slightly different versions of the same patch ...
> 
> And commit 01e4c32c668251e74eb179ee1207c075466c4ef8 ("osduld: No need to
> use dev_set_drvdata on embedded devices") from the osd also contributes
> to the conflict.
> 

James has squashed these two patches together. Which do belong together
I should say. In my tree they are separate. I will change my tree to
match James's.

Thanks James, I prefer it much better this way.

> I fixed it up (the obvious way) and can carry the fix for a while.

Thanks
Boaz
