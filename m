Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbZLPPOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbZLPPOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbZLPPOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:14:22 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:54681 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632AbZLPPOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:14:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oqUef4J90Sai8yTHzHgAK+UaS1kBCrMOebH5evVBGKgbkYUC+CwvwyN+T8nwnMm+pP
         vEEG4HkmVaRGVrN1hKqfuYRzFoPSILx6mdc1lcELinTffBmIO9pwfEG60VFsCzOXQKe7
         sT5ApisTgX5XCVCX7XULKh8kUVsAFNCBTHrOE=
Date: Wed, 16 Dec 2009 23:14:50 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 0/5] use DECLARE_COMPLETION_ONSTACK for non-constant
	completion
Message-ID: <20091216151450.GA2804@hack>
References: <1260974161-6934-1-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260974161-6934-1-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 10:35:56PM +0800, Yong Zhang wrote:
>The _ONSTACK variant should be used for on-stack completion,
>otherwise it will break lockdep.
>
>Yong Zhang (5):
> aha152x: use DECLARE_COMPLETION_ONSTACK for non-constant completion
> mISDN: use DECLARE_COMPLETION_ONSTACK for non-constant completion
> USB: use DECLARE_COMPLETION_ONSTACK for non-constant completion
> hwmon: use DECLARE_COMPLETION_ONSTACK for non-constant completion
> powerpc/iseries: use DECLARE_COMPLETION_ONSTACK for non-constant completion

These all look fine for me.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

For lockdep stuff, you should Cc Peter, adding him into Cc...

Thanks.


>
> arch/powerpc/platforms/iseries/viopath.c |    2 +-
> drivers/hwmon/ams/ams-pmu.c              |    4 ++--
> drivers/isdn/mISDN/l1oip_core.c          |    2 +-
> drivers/scsi/aha152x.c                   |    2 +-
> drivers/usb/gadget/fsl_qe_udc.c          |    2 +-
> drivers/usb/gadget/fsl_udc_core.c        |    2 +-
> drivers/usb/gadget/langwell_udc.c        |    2 +-
> 7 files changed, 8 insertions(+), 8 deletions(-)
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
