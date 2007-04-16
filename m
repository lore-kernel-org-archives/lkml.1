Return-Path: <linux-kernel-owner+w=401wt.eu-S1030958AbXDPUVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030958AbXDPUVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030959AbXDPUVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:21:00 -0400
Received: from quechua.inka.de ([193.197.184.2]:43589 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030958AbXDPUU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:20:59 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <75b66ecd0704161226t40fdb322xfc174dbf3d097bb0@mail.gmail.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HdXh3-0004K1-00@calista.eckenfels.net>
Date: Mon, 16 Apr 2007 22:20:57 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <75b66ecd0704161226t40fdb322xfc174dbf3d097bb0@mail.gmail.com> you wrote:
>> Unfortunatelle Latency is critical for a number of critical applications
>> like databases or file based transaction systems (mail, news) - mainly the
>> users of fsync().
> 
> Whether you mix audio in userspace or kernel does not impact latency -
> you still need to schedule the application playing audio every N
> milliseconds or there will be dropouts.  I don't see where audio
> mixing issue has any relevance to this thread.

Well, I was not talking about Audio - I was saying that there are a class of
applications which need low latency on commits (fsync or rename).

And for the audio mixer, the problem is that you have multiple reschedules
and data ping pong if you do user mode mixing - i guess.

Anyway.. not important. I still think filesystem servers can be a good
thing. And I really hope we will find some interesting numbers on ZFS
advantages...

Gruss
Bernd
