Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbYEFTuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbYEFTuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762330AbYEFTu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:50:29 -0400
Received: from 1wt.eu ([62.212.114.60]:4157 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762066AbYEFTu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:50:27 -0400
Date: Tue, 6 May 2008 21:50:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: bad pmd ffff810000207808(9090909090909090).
Message-ID: <20080506195014.GS8474@1wt.eu>
References: <874p9biqwj.fsf@duaron.myhome.or.jp> <alpine.LNX.1.10.0805061424090.16731@fbirervta.pbzchgretzou.qr> <87zlr3zj9x.fsf@duaron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zlr3zj9x.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 09:52:58PM +0900, OGAWA Hirofumi wrote:
> Jan Engelhardt <jengelh@medozas.de> writes:
> 
> > On Tuesday 2008-05-06 14:00, OGAWA Hirofumi wrote:
> >
> >>I've found today the following error in syslog. It seems have a strange
> >>pattern. And it also happened at a month ago.
> >>
> >>Any idea for debuging this?
> >>
> >
> > 90 is NOP on x86, perhaps something got rooted?
> 
> I see. I'm not sure, but I didn't notice this soon, maybe it worked as
> almost usual.

I got immediate same feeling as Jan here. It looks very much like someone
has tried to inject code into your system. The problem is that you don't
know if this finally succeeded. Maybe some backdoor is now installed in
your kernel. If I were you, I would isolate the machine, reboot it on CD
and check MD5s (particularly the ones of the kernel and modules) before
rebooting it.

Willy

