Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbYKWVsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbYKWVsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 16:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbYKWVsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 16:48:36 -0500
Received: from buick.jordet.net ([193.91.240.190]:50130 "EHLO buick.jordet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbYKWVsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 16:48:36 -0500
Subject: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
From: Stian Jordet <liste@jordet.net>
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com
In-Reply-To: <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>
References: <1226760254.5089.11.camel@chevrolet>
	 <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 22:48:28 +0100
Message-Id: <1227476908.32357.5.camel@chevrolet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ti., 18.11.2008 kl. 11.51 -0200, skrev Sergio Luis: 
> please post your config and dmesg output. It might help people try to
> identify something wrong.

(see http://marc.info/?l=linux-kernel&m=122676220019858&w=2 for the
start of this thread)

Hmm. I have now converted my root and /home filesystems to ext3, and
that actually fixed it (!). I have no idea why xfs is performing so
extremely poorly on this machine, i'm running xfs on every filesystem on
eight other computers (one heavy loaded server, as well).

Anyway, I'm now unpacking the 2.6.27.6 kernel in 15 seconds, with xfs on
the same array it used between five and six minutes.

I still have a xfs array, and when I copy files to or from that array,
the gnome session practically freezes, and the load average easily goes
beyond 10.

How should I debug this? I'm not very eager about reformatting my 1,5TB
xfs array... Besides, xfs have never let me down earlier.

Thanks.

Please cc me on any replies.

Regards,
Stian

