Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbZGJAIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbZGJAIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 20:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZGJAIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 20:08:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38866
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbZGJAII convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 20:08:08 -0400
Date: Thu, 09 Jul 2009 17:08:11 -0700 (PDT)
Message-Id: <20090709.170811.21077750.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: jolsa@redhat.com, netdev@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       fbl@redhat.com, nhorman@redhat.com, htejun@gmail.com, jarkao2@gmail.com,
       oleg@redhat.com, davidel@xmailserver.org
Subject: Re: [PATCHv7 2/2] memory barrier: adding smp_mb__after_lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A557153.8000108@gmail.com>
References: <20090708220717.GB2945@jolsa.redhat.com>
	<20090708221031.GD2945@jolsa.redhat.com>
	<4A557153.8000108@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 09 Jul 2009 06:25:55 +0200

> Jiri Olsa a écrit :
>> Adding smp_mb__after_lock define to be used as a smp_mb call after
>> a lock.
>> 
>> Making it nop for x86, since {read|write|spin}_lock() on x86 are
>> full memory barriers.
>> 
>> wbr,
>> jirka
>> 
>> 
>> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Also applied, thanks everyone!
