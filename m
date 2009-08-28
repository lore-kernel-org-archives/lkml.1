Return-Path: <linux-kernel-owner+w=401wt.eu-S1751902AbZH1OrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbZH1OrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 10:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZH1OrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 10:47:08 -0400
Received: from mail.tpi.com ([70.99.223.143]:2464 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbZH1OrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 10:47:06 -0400
Message-ID: <4A97EDE4.90705@canonical.com>
Date: Fri, 28 Aug 2009 08:47:00 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: torvalds@linux-foundation.org, ebiederm@xmission.com, brian@xyzw.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] inotify regresion in -rc8 causes boot hang/failure
References: <1251468443.2947.7.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1251468443.2947.7.camel@dhcp231-106.rdu.redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> The following changes since commit 326ba5010a5429a5a528b268b36a5900d4ab0eba:
>   Linus Torvalds (1):
>         Linux 2.6.31-rc8
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/eparis/notify.git for-linus
> 
> Brian Rogers (1):
>       inotify: do not send a block of zeros when no pathname is available
> 
>  fs/notify/inotify/inotify_user.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

This fixes boot problems on a RAID-0 box with 4 disks.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
