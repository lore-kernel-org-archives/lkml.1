Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbYIAQha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbYIAQha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYIAQgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:36:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:51918 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbYIAQgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=IHdYQD8o+BsCyUZRtDUamsiyBkp0Ebv7uaOfTVAounI8fPXt9byNyCYJZiCZUiTdOp
         ul9rkrynv+Ca8dpxFzD8SCw0XN0v6kSwDLjak1hj8TTNpjrM3Stqz0pk3Fb5Maj4k2hZ
         ygbvPat1HoKs5hG7ylljFF0YZYAJqXsgT5DWs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH #blk-for-2.8] init: DEBUG_BLOCK_EXT_DEVT requires explicit root= param
Date: Mon, 1 Sep 2008 18:34:02 +0200
User-Agent: KMail/1.9.9
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dm-devel@redhat.com
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <20080901113059.GO20055@kernel.dk> <48BBD429.50907@kernel.org>
In-Reply-To: <48BBD429.50907@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809011834.02577.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2008, Tejun Heo wrote:
> DEBUG_BLOCK_EXT_DEVT shuffles SCSI and IDE device numbers and root
> device number set using rdev become meaningless.  Root devices should
> be explicitly specified using textual names.  Warn about it if root
> can't be found and DEBUG_BLOCK_EXT_DEVT is enabled.  Also, add warning
> to the help text.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Thanks Tejun.  With this patch I'm also fine with having
DEBUG_BLOCK_EXT_DEVT enabled by default.
