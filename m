Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbYANX5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbYANX5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 18:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYANX5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 18:57:06 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:51264 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbYANX5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 18:57:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KRUG/88l9fSZ3N0twKarN4Pi8LzSx5bODM9/DGYtDo6h1rbg0KdR2HG/qTpKOW7iXYCSJzzT3VjyU3qytNCQW1H/bWych3XTDbBhMwtu62goFvCbbzWFVEOtRjAS3TCNG38sJ79QyDFSSMM0bp1iNC7PDjHAYVbSFVeZl9H3B4Y=
Message-ID: <478BF6C9.4090306@gmail.com>
Date: Tue, 15 Jan 2008 08:56:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>
CC: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc7
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>	<20080108015012.2e518dd4@werewolf>	<478429B2.2030002@gmail.com>	<20080110102505.62097da1@werewolf>	<47861930.7010708@gmail.com>	<20080114001914.1e05fdb5@werewolf>	<478AA56F.9020506@gmail.com> <20080115003818.0bf10703@werewolf>
In-Reply-To: <20080115003818.0bf10703@werewolf>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> I finally found the bad drive (the most obvious one as I would expect,
> it was recycled from an older box...).
> I tried removing completely the drive from power and controller, and then
> running with it powered but not connected. No single error any more on
> any of the other 3 drives. I have been updating my distro, rebuilding the
> rpm database, moving big files between drives, even all at the same time.
> No error.
> 
> I can't believe it, but a bad drive was causing timeouts on other drive
> _on other controller_, the bad one was attached to the Promise and the
> good ones on the ICH5 SATA (both integrated in motherboard).
> Or there is a strange interaction in my board (Asus PC-DL), or there is
> a nasty bug in the kernel...

Hmmm... That's an interesting story.  Can you please connect the faulty
harddrive to a separate power supply and connect the drive to the
controller and see whether IO errors go away?

-- 
tejun
