Return-Path: <linux-kernel-owner+w=401wt.eu-S965238AbXBQMtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965238AbXBQMtx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 07:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965252AbXBQMtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 07:49:52 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:54152 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965238AbXBQMtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 07:49:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LTwraIlM9c52IF81LS1KuWk9vwuNq6asCHNYH5pYghN0iqBPpzOhSQLTj1XXCho/U8kXS5G1RUSQmQBzL7+9U9lq4SUsAA7/RXuhCMaWvpRaZ4WarcFqklLyBV+lBqjqkwpvfBB2vBegwTT7r+X9pJcxvi6WgY3v8AnP2yk0hwc=
Message-ID: <d72aa1340702170449n1aa61777l6c9c7e525102db00@mail.gmail.com>
Date: Sat, 17 Feb 2007 07:49:51 -0500
From: "Marcus Haebler" <haebler@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>,
       "Pablo Sebastian Greco" <lkml@fliagreco.com.ar>
Subject: Re: SATA problems
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45B6BC6D.8070301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <459A674B.3060304@fliagreco.com.ar> <459B9F91.9070908@gmail.com>
	 <459BC703.9000207@fliagreco.com.ar> <459C8A5E.5010206@gmail.com>
	 <459CFE7B.6090306@fliagreco.com.ar>
	 <459DC2EE.1090307@fliagreco.com.ar> <45A1AB3F.1080408@gmail.com>
	 <45B649BF.5030705@fliagreco.com.ar> <45B6BC6D.8070301@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I opened a bug report (228979) on bugzilla.redhat.com on this one because
I have the same issue under FC6 2.6.19-1.2895. Here is the link:

    https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=228979

Do you have any more updates on this problem? Is there a way I can help
by providing debug data?

Thanks,

Marcus

On 1/23/07, Tejun Heo <htejun@gmail.com> wrote:
> Pablo Sebastian Greco wrote:
> > Well, it took me a few days,  but I think I'm ready to report back. One
> > of the drives was failing, and it stopped after rewiring power supply so
> > the last problem seems to be corrected.
> > OTOH, your blacklist seems to be needed too, now I'm running FC6
> > distribution kernel 2.6.19-1.2895.fc6 (2.6.19.2 + some patches by
> > fedora) and setting
> > echo 1 >/sys/block/sdX/device/queue_depth
> > on all the SAMSUNG drives (sdb, sdc and sdd)
> > The second I type
> > echo 31 >/sys/block/sdX/device/queue_depth
> > on any of the drives I get these messages
> >
> > Jan 23 12:36:30 squid kernel: BUG: warning: (ap->ops->error_handler &&
> > ata_tag_valid(ap->active_tag)) at
> > drivers/ata/libata-core.c:4602/ata_qc_issue() (Not ta
> > inted)
>
> This is kernel bug that needs fixing.  I'll investigate.
>
> --
> tejun
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
