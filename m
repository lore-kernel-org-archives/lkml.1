Return-Path: <linux-kernel-owner+w=401wt.eu-S1762539AbXGQApg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762539AbXGQApg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbXGQAp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:45:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:59553 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312AbXGQApZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=LH+o99pxLxrLx+OD4+R31d+1vjZ+W4nAfplg04ICGsF4gyA9uFLxXeKR6mm6zMe4x+iZXmL3zAvMi2mESPfmbLmNSm8+LA52+WmtAb2z/BqR9COhC+YPD8iTv9+MHGMrCic4fwf1UU0hxczGVaEf/ioKjYMtaL6mjOQMVHCK3Vg=
Message-ID: <469C10F6.3050008@googlemail.com>
Date: Tue, 17 Jul 2007 02:44:38 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi@vger.kernel.org
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
References: <469BD9C8.4000808@googlemail.com>
In-Reply-To: <469BD9C8.4000808@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hello,
>
> sdparm and hdparm are broken for me on git (
> abce891a10559343d8ac9f79b46d78afdba63a40 )
>
>
> ~$ sudo hdparm  /dev/sdc
>
> /dev/sdc:
>  BLKROGET failed: Inappropriate ioctl for device
>  BLKRAGET failed: Inappropriate ioctl for device
>  BLKGETSIZE failed: Inappropriate ioctl for device
>
>
> ~$ sudo sdparm  --all /dev/sdc
> unable to access /dev/sdc, ATA disk?
>
>   

Well it is bsg , setting BLK_DEV_BSG=n fixed all this errors.

Maybe a bit off topic but it depends on EXPERIMENTAL so why the the menu
is not telling this ? and why the default is 'y' for it ?

IMO everything depends on EXPERIMENTAL should

1) Tell it is EXPERIMENTAL ( visible to the user in menu ) " Foo New
stuff ( EXPERIMENTAL ) "
2) Should not default to 'y' , is up to the users/admins to set
EXPERIMENTAL things to Y/M , isn't it ?


( PS: there are even defconfigs with EXPERIMENTAL things set to y but
this is really off topic )


Regards,

Gabriel C



