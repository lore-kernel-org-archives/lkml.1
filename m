Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYJ1N6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYJ1N6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 09:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYJ1N6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 09:58:41 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37941 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbYJ1N6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 09:58:40 -0400
Date: Tue, 28 Oct 2008 14:57:31 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Zeno Davatz <zdavatz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [sda] write cache: enabled, read cache:enabled: doesn't support DPO or FUA, sda:
Message-ID: <20081028135730.GM22217@kernel.dk>
References: <40a4ed590810280648u2fc01a6dybfe3d5f49aa29f94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40a4ed590810280648u2fc01a6dybfe3d5f49aa29f94@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28 2008, Zeno Davatz wrote:
> Dear List
> 
> After my latest git pull from
> 
> url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> I done
> 
> make silentoldconfig
> make modules_install
> 
> copied the bzImage to /boot and ran lilo.
> 
> When I want to boot into 2.6.28-rc2 I get:
> 
> [sda] write cache: enabled, read cache:enabled: doesn't support DPO or FUA, sda:
> 
> Also see my screenshot:
> 
> http://farm4.static.flickr.com/3213/2980651545_de81680bf9_o.jpg

How recent is that pull? This looks like something fixed in-between -rc1
and -rc2. So I'd double check that you are after or on -rc2 and that you
are booting the right kernel.

-- 
Jens Axboe

