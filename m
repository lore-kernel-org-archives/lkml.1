Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbZGPIET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbZGPIET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZGPIES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:04:18 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:59733 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbZGPIEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:04:14 -0400
Message-ID: <4A5EDEF7.7090303@cosmosbay.com>
Date: Thu, 16 Jul 2009 10:04:07 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Caleb Cushing <xenoterracide@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: e1000e 2.6.30.1 massive packet loss
References: <81bfc67a0907160049q3d43093cy52276f0fe1157d89@mail.gmail.com>
In-Reply-To: <81bfc67a0907160049q3d43093cy52276f0fe1157d89@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 16 Jul 2009 10:04:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caleb Cushing a écrit :
> So from 2.6.30 to .1 I noticed that via an icmp test (mtr) 20-50%
> packet loss web browsing became impractical (downgrading fixed the
> issue). I'm wondering if the change to the driver (w/ msi) is the
> cause? also wondering if this is known and will be fixed in .2 I can
> provide more information if necessary.
> 

Added netdev to get more attention to this.

What do you call 20-50% packet loss ?
(Losses to icmp flood itself, or tcp losses ?
Is the machine answering to icmp flood, or is it the origin ?

Are you saying packet loss was not occurring with 2.6.30 ?

Could you describe your methodology ?

You could give us results of "cat /proc/interrupts" from both
versions, because it sounds as an interrupt affinity problem.

# cat /proc/interrupts
# tc -s -d qdisc
# ifconfig -a
