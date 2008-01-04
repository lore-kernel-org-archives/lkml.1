Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYADBTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYADBTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYADBT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:19:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:61225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYADBT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:19:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=j5bXNRGSp9N7a8HgUpwkzPzGoVuln8bWtOtZ3Nq4UICcetfGwdgteUcU4RnQ3Rvjo16668i6K020bqN9VoOOIYP31id2DyF2pe5sr5ZB3vCjn2lbxZugbtChIDkW3vSuEqGBToudE20tKBX9l8+zOcGPLSOjNcoJJacdQq5f3uY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [RESEND PATCH 0/10] ide-floppy redux p1
Date: Fri, 4 Jan 2008 01:14:33 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801040114.33520.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 03 January 2008, Borislav Petkov wrote:
> 
> Hi Bart,
> 
> here's the unfinished redux of ide-floppy which i'm REsending now so that we could
> sinchronize trees. The original send got busted in vger's filters due to syntax
> error in the Message-ID tag.
> 
>  Documentation/ide/ChangeLog.ide-floppy.1996-2002 |   64 ++
>  drivers/ide/ide-floppy.c                         | 1248 +++++++---------------
>  drivers/ide/ide-floppy.h                         |  351 ++++++
>  include/linux/cdrom.h                            |    1 +
>  4 files changed, 819 insertions(+), 845 deletions(-)

I applied patch #1, patches #3, #4, #7 and #10 can be applied immediately
if you move them at the beggining of the patch series.  The rest requires
some more work but they are "almost there" (more comments in replies to
particular patches).

Thanks,
Bart
