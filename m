Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbZEWBEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbZEWBEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 21:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZEWBD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 21:03:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:30404 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZEWBD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 21:03:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xANjHZsXtreHNN4CqsY2aw4zpaQgLYv/vZUu05PMsogbim23yI/65Pq30av+vFZJLe
         bfw+8SE+qgMWDqmuCf2fn0jETf76CCwPFjJrzKOUoAG/OdLlBLB/lYpvJ6o+5JTp1SpY
         UjAxSvwR1T7ZC3/nbofrvuodpIVrhlg7g+ud8=
MIME-Version: 1.0
In-Reply-To: <4A1743C5.9020803@candelatech.com>
References: <4A1743C5.9020803@candelatech.com>
Date: Sat, 23 May 2009 09:03:58 +0800
Message-ID: <d82e647a0905221803w487fcdb3k2319bdaa7d9cc559@mail.gmail.com>
Subject: Re: Question on lockdep and sysrq - d
From: Ming Lei <tom.leiming@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See http://marc.info/?l=linux-kernel&m=124211522525625&w=2.

thanks.

2009/5/23 Ben Greear <greearb@candelatech.com>:
> Hello!
>
> I'm trying to debug an apparent deadlock in some code I'm
> writing.
>
> When I do a sysrq 'd', I get a nice dump of locks (I have lockdep enabled).
>
> However, the output appears to show multiple processes holding the
> same locks (rtnl_mutex, for example):
>
> Showing all locks held in the system:
> 3 locks held by events/11/63:
>  #0:  (events){--..}, at: [<ffffffff8104f71e>] run_workqueue+0xb1/0x216
>  #1:  ((linkwatch_work).work){--..}, at: [<ffffffff8104f71e>]
> run_workqueue+0xb1/0x216
>  #2:  (rtnl_mutex){--..}, at: [<ffffffff8125def1>] rtnl_lock+0x12/0x14
> 1 lock held by irqbalance/3360:
>  #0:  (rtnl_mutex){--..}, at: [<ffffffff8125def1>] rtnl_lock+0x12/0x14
> 1 lock held by hald/3605:
>  #0:  (rtnl_mutex){--..}, at: [<ffffffff8125def1>] rtnl_lock+0x12/0x14
> ...
>
> Is this merely showing processes that are blocked on trying to acquire these
> locks?
>
> If so, is there any way to tell which processes have fully acquired locks
> v/s
> just waiting to acquire them?
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Lei Ming
