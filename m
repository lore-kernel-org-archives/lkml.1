Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbYCYOUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbYCYOUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYCYOTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:19:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58250 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbYCYOTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:19:52 -0400
Date: Tue, 25 Mar 2008 15:22:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, ebiederm@xmission.com,
       xemul@openvz.org, pavel@ucw.cz, sds@tycho.nsa.gov, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080325142259.GO2170@one.firstfloor.org>
References: <20080323135110.GA294@tv-sign.ru> <20080324152906.dee7b272.akpm@linux-foundation.org> <20080324225611.GA157@tv-sign.ru> <20080324160819.cea2d921.akpm@linux-foundation.org> <87r6dzi0mw.fsf@basil.nowhere.org> <m3fxuedh3m.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3fxuedh3m.fsf@maximus.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I like the general idea -- i used to patch kernels to allow this too,
> > but it is dangerous.
> 
> Though root-only. Root doesn't want to be limited and knows better
> anyway. 

The problem is that you can deadlock if you are not very careful.

-Andi
