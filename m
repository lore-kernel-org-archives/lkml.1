Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbZLJVM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbZLJVM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761580AbZLJVMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:12:24 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46311 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761318AbZLJVMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:12:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=wUmGKwLxobTk0wOzDs2hjOe4tzBwCz+4Lqy3S/7IKezAKGXVfrT+G7OrZ8FLUj0r2V
         p2Z7Jpex85igJK0Rpxs4ISCQ1juO/CInxnKkhxE/QjT7qLcmhHs/UMEgs+5rCJHIVbDg
         q/ubTmxHhVqYsVFa0yrwV9NVAfP9orjjVaZGo=
Date: Thu, 10 Dec 2009 23:12:23 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Will Dyson <will.dyson@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, Xavier Bestel <xavier.bestel@free.fr>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm
Message-ID: <20091210231223.491d47eb@daedalus.pq.iki.fi>
In-Reply-To: <8e6f94720912101235l30d05c03m54b769d9fd6ac35d@mail.gmail.com>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	<alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	<1260459601.18520.26.camel@skunk>
	<alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	<6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	<alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
	<20091210214948.3d3c958c@daedalus.pq.iki.fi>
	<8e6f94720912101235l30d05c03m54b769d9fd6ac35d@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 15:35:08 -0500
Will Dyson <will.dyson@gmail.com> wrote:

> This seems similar to the unfortunate situation with the b43
> wireless card firmware. Broadcom refuses to provide the firmware
> under a redistributable license (or even as files separate from
> their proprietary drivers). This did not stop b43 from being
> included in Linux. Distributions have dealt with it by providing
> a script that downloads the proprietary driver and extracts the
> firmware from it to files in /lib/firmware.
> 
> Do you think that a similar solution for nouveau would be legally
> problematic? Or is the issue technical, since you mention that the
> ctxprogs were obtained by mmiotrace, instead of a more
> straightforward extraction from the binary driver blobs?

It is definitely a lot harder than a script that just downloads
something. It would have to:
- download the proprietary driver
- install it and load it into the kernel
- activate mmiotrace (if it even is compiled in)
- reconfigure and start X and quit
- analyse the mmiotrace log to extract the ctxprog and ctxvals
- undo all the proprietary setup

I cannot comment on the legal side, but the practise sounds too
cumbersome.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
