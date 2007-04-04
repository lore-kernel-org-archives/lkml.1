Return-Path: <linux-kernel-owner+w=401wt.eu-S934053AbXDDAub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053AbXDDAub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934054AbXDDAub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:50:31 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:47813 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934053AbXDDAuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:50:24 -0400
Date: Wed, 4 Apr 2007 02:48:26 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 13/16] show-pipesize-in-stat.diff
In-Reply-To: <20070402124107.06294b2e.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.61.0704040243130.10155@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704012010040.12316@yvahk01.tjqt.qr>
 <20070402124107.06294b2e.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 2 2007 12:41, Eric Dumazet wrote:
>
>The following patch does the right thing for pipes, I let you doing
>the same for sockets...

Is struct sock->sk_receive_queue->qlen actually the thing I am
looking for? (Previously, I had struct sock->sk_rcvbuf, which was
obviously wrong.)

Thanks,
Jan
-- 
