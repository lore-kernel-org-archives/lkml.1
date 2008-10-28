Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYJ1OHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYJ1OHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYJ1OHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:07:05 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56270 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbYJ1OHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:07:04 -0400
Date: Tue, 28 Oct 2008 15:04:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Zeno Davatz <zdavatz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [sda] write cache: enabled, read cache:enabled: doesn't support DPO or FUA, sda:
Message-ID: <20081028140449.GN22217@kernel.dk>
References: <40a4ed590810280648u2fc01a6dybfe3d5f49aa29f94@mail.gmail.com> <20081028135730.GM22217@kernel.dk> <40a4ed590810280703q665ed37du3f8c25df0855dc5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40a4ed590810280703q665ed37du3f8c25df0855dc5d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(don't top post)

> On Tue, Oct 28, 2008 at 2:57 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Tue, Oct 28 2008, Zeno Davatz wrote:
> >> Dear List
> >>
> >> After my latest git pull from
> >>
> >> url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> >>
> >> I done
> >>
> >> make silentoldconfig
> >> make modules_install
> >>
> >> copied the bzImage to /boot and ran lilo.
> >>
> >> When I want to boot into 2.6.28-rc2 I get:
> >>
> >> [sda] write cache: enabled, read cache:enabled: doesn't support DPO or FUA, sda:
> >>
> >> Also see my screenshot:
> >>
> >> http://farm4.static.flickr.com/3213/2980651545_de81680bf9_o.jpg
> >
> > How recent is that pull? This looks like something fixed in-between -rc1
> > and -rc2. So I'd double check that you are after or on -rc2 and that you
> > are booting the right kernel.
>
> That Pull is from right after Linus released 2.6.28-rc2. I always pull
> after Linus releases an rc and notifys everyone through the list.
> 
> I will pull again right now and try again.

Please do, and if it still breaks then use netconsole or a serial
console to capture all boot messages!

-- 
Jens Axboe

