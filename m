Return-Path: <linux-kernel-owner+w=401wt.eu-S2992611AbXDDFEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992611AbXDDFEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992621AbXDDFEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:04:13 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:58626 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992611AbXDDFEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:04:11 -0400
Message-ID: <461331BB.6000202@cosmosbay.com>
Date: Wed, 04 Apr 2007 07:03:55 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 13/16] show-pipesize-in-stat.diff
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012010040.12316@yvahk01.tjqt.qr> <20070402124107.06294b2e.dada1@cosmosbay.com> <Pine.LNX.4.61.0704040243130.10155@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704040243130.10155@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 04 Apr 2007 07:04:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt a écrit :
> On Apr 2 2007 12:41, Eric Dumazet wrote:
>> The following patch does the right thing for pipes, I let you doing
>> the same for sockets...
> 
> Is struct sock->sk_receive_queue->qlen actually the thing I am
> looking for? (Previously, I had struct sock->sk_rcvbuf, which was
> obviously wrong.)
> 

find net | xargs grep -n SIOCINQ

I suspect you will find unix_ioctl() in net/unix/af_unix.c ?

BTW, my patch only worked for pipes, not fifos. Ie pipe(), not 
open("/some/fifo.p", ...)


