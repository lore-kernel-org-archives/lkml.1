Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbXGIMrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbXGIMrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXGIMr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:47:28 -0400
Received: from tristate.vision.ee ([194.204.30.144]:56161 "HELO mail.city.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752063AbXGIMr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:47:26 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2007 08:47:26 EDT
Message-ID: <46922CCB.8030303@vision.ee>
Date: Mon, 09 Jul 2007 15:40:43 +0300
From: =?UTF-8?B?TGVuYXIgTMO1aG11cw==?= <lenar@vision.ee>
User-Agent: Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: 2.6.22-rc6-mm1-cfs-v19 Unable to handle kernel NULL pointer	dereference
 (reproducable)
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de>
In-Reply-To: <20070708051452.GA4140@gentoox2.trippelsdorf.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Trippelsdorf wrote:
> Just got this oops while I was updating my system:
>
> Unable to handle kernel NULL pointer dereference at 00000000000002a6 RIP:
>  [<ffffffff802861b6>] vfs_permission+0x6/0x10
>   
The same thing just happened here during dist-upgrade with
stock ubuntu 2.6.22-7-generic x86_64 kernel (based on -rc4 I think):

[ 6361.299928] Unable to handle kernel NULL pointer dereference at 
00000000000002a2 RIP:
[ 6361.299933]  [<ffffffff802a3526>] vfs_permission+0x6/0x10

ext3 in use.

L.

