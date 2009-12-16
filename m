Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbZLPFOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbZLPFOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZLPFOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:14:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39288
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400AbZLPFOl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:14:41 -0500
Date: Tue, 15 Dec 2009 21:14:41 -0800 (PST)
Message-Id: <20091215.211441.39161790.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: fweisbec@gmail.com, nhorman@tuxdriver.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: packet_sendmsg_spkt sleeping from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B27AF77.7010809@gmail.com>
References: <4B26B09A.7050607@gmail.com>
	<20091215151302.GD5833@nowhere>
	<4B27AF77.7010809@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 15 Dec 2009 16:47:03 +0100

> Le 15/12/2009 16:13, Frederic Weisbecker a écrit :
> 
>> Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
>> 
> 
> Thanks for testing Frederic, here is the official patch submission then :)
> 
> 
> [PATCH] packet: dont call sleeping functions while holding rcu_read_lock()

Applied, thanks.
