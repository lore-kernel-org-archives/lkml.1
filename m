Return-Path: <linux-kernel-owner+w=401wt.eu-S932925AbXIJMFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbXIJMFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbXIJMDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:03:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53055 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbXIJMDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:03:35 -0400
Subject: Re: 2.6.23-rc5: possible irq lock inversion dependency detected
From: Peter Zijlstra <peterz@infradead.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <alpine.DEB.0.999.0709021455510.7103@sheep.housecafe.de>
References: <alpine.DEB.0.999.0709021455510.7103@sheep.housecafe.de>
Content-Type: text/plain
Date: Mon, 10 Sep 2007 14:03:33 +0200
Message-Id: <1189425813.21778.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-02 at 15:11 +0200, Christian Kujau wrote:
> Hi,
> 
> after upgrading to 2.6.23-rc5 (and applying davem's fix [0]), lockdep 
> was quite noisy when I tried to shape my external (wireless) interface:
> 
> [ 6400.534545] FahCore_78.exe/3552 just changed the state of lock:
> [ 6400.534713]  (&dev->ingress_lock){-+..}, at: [<c038d595>] netif_receive_skb+0x2d5/0x3c0
> [ 6400.534941] but this lock took another, soft-read-irq-unsafe lock in the past:
> [ 6400.535145]  (police_lock){-.--}
> 
> This happened when I executed: http://nerdbynature.de/bits/2.6.23-rc5/qos.sh.txt
> (using iproute2-ss070313). The is still running, I just noticed a short 
> hickup, probably when it was busy writing the warning to the disk.
> 
> More details and .config: http://nerdbynature.de/bits/2.6.23-rc5/

seems unavailable at this time, please submit the whole lockdep report
if possible.

