Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbYB2Cuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbYB2Cuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbYB2CuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:50:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:56950 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753846AbYB2CuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:50:23 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX18nGe9TcHUnfVYy5anKJ/61iJVr597CKK2Oi7Fabp
	E2dNGWFIAJybic
Message-ID: <47C772E9.2000000@gmx.net>
Date: Fri, 29 Feb 2008 04:50:17 +0200
From: Dimitrios Apostolou <jimis@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SeaMonkey/1.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: swap file over jffs2 partition
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

I intend to build a diskless linux system (root over NFS). Because it
has 1GB of embedded flash storage, I'm thinking of using this as swap 
(I've been bitten many times by the problems linux has with *no* 
swap...). And to avoid wearing out the flash storage too fast, I 'm 
thinking to format the 1GB partition as JFFS2, and create the swapfile 
on top of it.

I'm not so experienced with JFFS and I don't know if it's too heavy for
the CPU, for swapping. Or if there are other issues I 'll face. What do
you think about it? Any other ways you 'd propose?

Sorry for sending this at LKML but jffs-dev mailing list seems to be 
off. And JFFS is the only in-kernel filesystem that does wear-leveling, 
right?


Thanks in advance,
Dimitris

P.S. Please CC replies to me, as I'm not subscribed to the list.

