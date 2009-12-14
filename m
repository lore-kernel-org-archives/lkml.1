Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbZLNDdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbZLNDdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZLNDdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:33:02 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35270
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbZLNDdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:33:01 -0500
Date: Sun, 13 Dec 2009 19:33:01 -0800 (PST)
Message-Id: <20091213.193301.112613647.davem@davemloft.net>
To: yinghai@kernel.org
Cc: eric.dumazet@gmail.com, mingo@elte.hu, sri@us.ibm.com,
       herbert@gondor.apana.org.au, torvalds@linux-foundation.org,
       sjayaraman@suse.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: nfs broken in net-next? -- now in mainline -- bisected:
 d9f5950f90292f7cc42834338dfd5f44dc4cc4ca
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B256A7E.5000508@kernel.org>
References: <86802c440912121841j34cde8ecv892d7d74a32313ac@mail.gmail.com>
	<4B251CE4.9080401@gmail.com>
	<4B256A7E.5000508@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Sun, 13 Dec 2009 14:28:14 -0800

> Eric Dumazet wrote:
>> [PATCH] udp: udp_lib_get_port() fix
>> 
>> Now we can have a large udp hash table, udp_lib_get_port() loop
>> should be converted to a do {} while (cond) form,
>> or we dont enter it at all if hash table size is exactly 65536.
>> 
>> Reported-by: Yinghai Lu <yinghai@kernel.org>
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
 ...
> thanks. that fix the problem.

Applied, thanks everyone.
