Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZLUJ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZLUJ0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 04:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZLUJ0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 04:26:44 -0500
Received: from mx71.mail.ru ([94.100.176.85]:54656 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbZLUJ0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 04:26:43 -0500
Date: Mon, 21 Dec 2009 12:34:02 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <473915329.20091221123402@mail.ru>
To: Willy Tarreau <w@1wt.eu>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re[2]: epoll'ing tcp sockets for reading
In-reply-To: <20091221054615.GH9719@1wt.eu>
References: <1257480306.20091219150206@mail.ru>
 <alpine.DEB.2.00.0912190953160.4482@makko.or.mcafeemobile.com>
 <203216314.20091220013854@mail.ru>
 <alpine.DEB.2.00.0912191437530.4482@makko.or.mcafeemobile.com>
 <1059651918.20091220032610@mail.ru>
 <alpine.DEB.2.00.0912200750280.9679@makko.or.mcafeemobile.com>
 <20091220161422.GH32739@1wt.eu> <11246924033.20091221022619@mail.ru>
 <20091221054615.GH9719@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monday, December 21, 2009, 8:46:15 AM, Willy Tarreau wrote:
> Also, you should be conscious that the time you'd waste doing this is
> probably greater than the delta time between two reads on two distinct
> sockets, which means that in practice you will not necessarily report
> data in the network order, but you'll just be approximately fair
> between all FDs, at the expense of a high syscall overhead caused by
> small reads.
Agreed absolutely.
Anyway, I think I should stop abusing the ml at this point :)
Thank you!

Nikolai ZHUBR


