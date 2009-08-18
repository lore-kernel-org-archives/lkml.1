Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbZHRAtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbZHRAtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 20:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbZHRAtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 20:49:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37348
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbZHRAtI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 20:49:08 -0400
Date: Mon, 17 Aug 2009 17:49:19 -0700 (PDT)
Message-Id: <20090817.174919.265251863.davem@davemloft.net>
To: remi@remlab.net
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -next] phonet: fix build when PROC_FS is disabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <200908172343.44744.remi@remlab.net>
References: <4A89BF25.9010404@oracle.com>
	<200908172343.44744.remi@remlab.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rémi Denis-Courmont" <remi@remlab.net>
Date: Mon, 17 Aug 2009 23:43:43 +0300

> Le lundi 17 août 2009 23:35:49 Randy Dunlap, vous avez écrit :
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix phonet build when PROC_FS is not enabled:
>>
>> net/built-in.o: In function `pn_sock_open':
>> socket.c:(.text+0x23c649): undefined reference to `seq_open_net'
>> net/built-in.o:(.rodata+0x21018): undefined reference to `seq_release_net'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>

Applied, thanks.
