Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbXDZT0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbXDZT0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbXDZT0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:26:07 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:45344 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754956AbXDZT0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:26:05 -0400
Date: Thu, 26 Apr 2007 11:50:59 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Chase Venters <chase.venters@clientec.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <Pine.LNX.4.64.0704261321590.2588@turbotaz.ourhouse>
Message-ID: <Pine.LNX.4.63.0704261150210.9674@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com><1177573348.50
 25.224.camel@nigel.suspend2.net><alpine.LFD.0.98.0704260941310.9964@woody.l
 inux-foundation.org> <Pine.LNX.4.64.0704261321590.2588@turbotaz.ourhouse>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Chase Venters wrote:

> On Thu, 26 Apr 2007, Linus Torvalds wrote:
>
>> 
>> Once you have that snapshot image in user space you can do anything you
>> want. And again: you'd hav a fully working system: not any degradation
>> *at*all*. If you're in X, then X will continue running etc even after the
>> snapshotting, although obviously the snapshotting will have tried to page
>> a lot of stuff out in order to make the snapshot smaller, so you'll likely
>> be crawling.
>> 
>
> In fact... If you're just paging out to make a smaller snapshot (ie, not
> to free up memory), couldn't you just swap it out (if it's not backed by a
> file) then mark it as "half-released"... ie, the snapshot writing code
> ignores it knowing that it will be available on disk at resume, but then
> when the snapshot is complete it's still available in physical RAM,
> preventing user-space from crawling due to the necessity of paging it all
> back in?

your swap space may end up being re-used before you restore with std

David Lang
