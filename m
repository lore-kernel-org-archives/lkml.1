Return-Path: <linux-kernel-owner+w=401wt.eu-S933800AbYEFXV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800AbYEFXV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759391AbYEFXVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:21:15 -0400
Received: from 1wt.eu ([62.212.114.60]:4171 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374AbYEFXVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:21:14 -0400
Date: Wed, 7 May 2008 01:21:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: bad pmd ffff810000207808(9090909090909090).
Message-ID: <20080506232105.GA22457@1wt.eu>
References: <874p9biqwj.fsf@duaron.myhome.or.jp> <alpine.LNX.1.10.0805061424090.16731@fbirervta.pbzchgretzou.qr> <87zlr3zj9x.fsf@duaron.myhome.or.jp> <20080506195014.GS8474@1wt.eu> <87abj3nibc.fsf@duaron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87abj3nibc.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 08:06:47AM +0900, OGAWA Hirofumi wrote:
> Willy Tarreau <w@1wt.eu> writes:
> 
> >> I see. I'm not sure, but I didn't notice this soon, maybe it worked as
> >> almost usual.
> >
> > I got immediate same feeling as Jan here. It looks very much like someone
> > has tried to inject code into your system. The problem is that you don't
> > know if this finally succeeded. Maybe some backdoor is now installed in
> > your kernel. If I were you, I would isolate the machine, reboot it on CD
> > and check MD5s (particularly the ones of the kernel and modules) before
> > rebooting it.
> 
> Hm.. I've checked md5sum as far as I can do (/var/lib/dpkg/info/*.md5sums).
> It seems to have no difference except data files.
> 
> And this machine is in back of firewall of other machine, and the kernel
> is builded from source each every day or a hour or such.
> 
> So, it is unlikely...

OK. At least it was worth checking!

Regards,
Willy

