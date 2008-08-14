Return-Path: <linux-kernel-owner+w=401wt.eu-S1758354AbYHNIp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354AbYHNIp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbYHNIpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:45:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36284 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbYHNIph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:45:37 -0400
Message-ID: <48A3F0AA.3080806@pobox.com>
Date: Thu, 14 Aug 2008 04:45:30 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jie Yang <jie.yang@atheros.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] uninline atl1e_setup_mac_ctrl()
References: <20080808183334.GZ14495@cs181140183.pp.htv.fi>
In-Reply-To: <20080808183334.GZ14495@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> There doesn't seem to be a compelling reason why atl1e_setup_mac_ctrl() 
> is marked as "inline":
> 
> It's not used in any place where speed would matter much, and as long as 
> it has only one caller non-ancient gcc versions anyway inline it 
> automatically.
> 
> This patch fixes the following compile error with gcc 3.4:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/net/atl1e/atl1e_main.o
> atl1e_main.c: In function `atl1e_check_link':
> atl1e_main.c:50: sorry, unimplemented: inlining failed in call to 
> atl1e_main.c:196: sorry, unimplemented: called from here
> make[4]: *** [drivers/net/atl1e/atl1e_main.o] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied


