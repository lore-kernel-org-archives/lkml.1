Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZDMGOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZDMGOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 02:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZDMGOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 02:14:15 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:46030 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbZDMGOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 02:14:15 -0400
Date: Mon, 13 Apr 2009 08:16:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Daniel Collins <solemnwarning@solemnwarning.no-ip.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.28 /proc/diskstats
Message-ID: <20090413061619.GA1909@uranus.ravnborg.org>
References: <49E13D18.2090805@solemnwarning.net> <49E29386.20204@solemnwarning.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E29386.20204@solemnwarning.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 02:21:10AM +0100, Daniel Collins wrote:
> I've stepped through the commits in linux-2.6, the first revision with 
> this behavior is 074a7aca7afa6f230104e8e65eba3420263714a5

It would be a good idea to:
1) mention the subject of said path as no-one remember all these
SHA-1 anyway (but include the SHA-1 for reference.
2) copy the author of said patch.

The relevant patch is: "block: move stats from disk to part0"

I have copied Tejun and JEns.

The rest of the mail kept for reference.

	Sam


> 
> Daniel Collins wrote:
> >Hi
> >
> >Since 2.6.28, fd0 isn't visible in /proc/diskstats from boot, only 
> >after access/mount. It is visible in /sys/block/ from boot, so there 
> >are no issues detecting it. This may also affect other devices such as 
> >hda but I haven't tested this yet, my test system and QEMU both only 
> >have ram0-ram15 from boot. I have tested 2.6.30-rc1 and found the same 
> >behavior. Is this a bug or a deliberate change?
> >
> >Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
