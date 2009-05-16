Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZEPTPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZEPTPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 15:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZEPTPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 15:15:42 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63422 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756AbZEPTPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 15:15:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=VDIGfuuLUsgfGXYDfiYricMQ+mI22GtksSnZRpZHyiBta3QTXFcYJ41aHZf+QXRvK7
         J6yRRzq4yn1Q2UjabIFqlF+jqNm60TKgUoLxoVsowNZQ8i8ntSV9UHyZezkxnru1onvq
         8TmGteHWs0SN7e6/jM1LuKyBed15csh7ElgsU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/15 v2] ide-atapi: remove pc->buf and misc cleanups
Date: Sat, 16 May 2009 21:07:38 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905162107.38332.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 15 May 2009 07:11:18 Borislav Petkov wrote:
> Hi,
> 
> this is the newest respin of the current patchset with all issues from
> the previous review round fixed:
> 
> - 0003: fixed checkpatch issues
> 
> - 0005: documented additional change in the commit message
> 
> - 0009: converted to using bio_data() helper; pushed pc->buf removal to #12;
> 	moved unrelated changes to 0010
> 
> - 0014: updated/fixed checkpatch issues

Thanks.

> It also got rebased ontop of block/for-2.6.31 after Tejun's stuff got merged.

I would love to merge it but I'm hitting merge conflicts...

I can pull tj/block-peek-fetch into for-next but not block/for-2.6.31...

tj's top commit:

author	Tejun Heo <tj@kernel.org>
	Fri, 8 May 2009 23:45:23 +0000 (08:45 +0900)
committer	Tejun Heo <tj@kernel.org>
	Fri, 8 May 2009 23:45:23 +0000 (08:45 +0900)
commit	18c551bb4944dec0ce2c0a854b6694ed39ab58f6
tree	a2a59fd27626e930809a20546c0c02e1df498056
parent	88fd264e94d01b23339ce614be9141eb2db98e10

corresponding blocks's commit:

author	Tejun Heo <tj@kernel.org>
	Fri, 8 May 2009 02:54:16 +0000 (11:54 +0900)
committer	Jens Axboe <jens.axboe@oracle.com>
	Mon, 11 May 2009 07:52:18 +0000 (09:52 +0200)
commit	9934c8c04561413609d2bc38c6b9f268cba774a4
tree	30dd8f7be54f9b2e03094de9cd03b6a9ee2909cd
parent	2343046826a8ca426b07601d9593ee046c298b68

Looking at creation dates I suspect that somewhere along the way
something was rebased?

One quick temporary solution would be to recreate bp/pc-remove-buf
on top of tj/block-peek-fetch...
