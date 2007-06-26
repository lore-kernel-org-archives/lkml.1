Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbXFZBdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbXFZBdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 21:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXFZBdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 21:33:16 -0400
Received: from server.rillion.net ([207.210.78.215]:36190 "EHLO rillion.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbXFZBdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 21:33:15 -0400
Message-ID: <46806CCB.6020708@rillion.net>
Date: Tue, 26 Jun 2007 13:32:59 +1200
From: Graeme Sheppard <nodes@rillion.net>
User-Agent: Thunderbird 2.0.0.4 (X11/20070616)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Subject: Re: Patent or not patent a new idea
References: <46803772.7020408@rillion.net>
In-Reply-To: <46803772.7020408@rillion.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Posting it here seems the best thing to do.

To the inventor goes naming privilege and I'm calling this one softer raid.
It is a form of storage raid implemented in software, as contrasted to
software and hardware raid which are dependent on using required hardware.

To create a loop filesystem is straight forward. The commands are dd,
mkfs.*, mount -o loop. Basically what I propose is that the image file is
copied to another harddisk (in the case of ide not on the same cable) and
it too is mounted in conjunction of the original with cooperation. When a
read request for a block of say 100k is made, the kernel pulls 50k from
each disk - maybe a simple doubling of throughput.

That example is a raid 1 scenario. Other raid levels I don't think would be
so simple to achieve. Of course more than 2 disks could be harnessed.

The two big advantages I see over normal raid setups are 1) the disks need
not be the same size or from the same manufacturer; 2) the supporting code
would be cross-platform.

It allows users to more freely create and change partitions (which hold
softer raid images) and their sizes.

The downside is that softer raid would be slower than traditional raid
techniques on the right hardware, as softer raid goes through another
filesystem. Softer raid could be optimized for contiguous image files
perhaps.

Using softer raid could also provide sufficient throughput of flash devices
making for a great combo with low latency.

I am not versed enough to suggest how a kernel would implement the storage
access, in 512 or 4096 byte blocks or in what way the reassembling of
pieces would be done efficiently. Therefore I'm not completely sure of any
performance gains.

Is this a good idea or have I overlooked a catch and got lost?

