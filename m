Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982Ab0AVHTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab0AVHTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 02:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950Ab0AVHTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 02:19:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:44204 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751729Ab0AVHTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 02:19:23 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+WwKFqt+GWTDTbZfQu52KvuMJZgKuaDrKQA6Ot+G
	CoLx18p2Jn+Oev
Subject: Re: scheduler vs hardware? (was Re: another i7  (linux) bug?)
From: Mike Galbraith <efault@gmx.de>
To: Luca Zini <luca.zini@gmail.com>
Cc: aagaande@gmail.com, rdelcueto@hotmail.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>
In-Reply-To: <20100121215438.GK17684@ldl.fc.hp.com>
References: <201001211258.23499.luca.zini@gmail.com>
	 <20100121215438.GK17684@ldl.fc.hp.com>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 08:19:18 +0100
Message-Id: <1264144758.8074.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> if I run a cpu intensive process with the lowest priority (19
> from man nice) I obtain much better performance that with the
> highest priority available (-20 from man nice).
>
> For example the same file is processed by lame in 8.7 seconds
> at the lowest priority, and in 12 seconds at the highest
> priority.  Before posting a bug I wold like to understand if
> this is a problem related to the i7 mobile (my processor is a
> i7 Q720).
> 
> As far as I tested on the same laptop series (dell studio 15),
> with the same kernel this problem does not exists.

So you only see this on the i7.  That's odd.  Can you try 33-rc5?

Posting a reliable reproducer would be nice.  It'd also be nice to see
what all is running when you see this, and where.

	-Mike

