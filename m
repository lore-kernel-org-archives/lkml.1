Return-Path: <linux-kernel-owner+w=401wt.eu-S934427AbYEVMJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427AbYEVMJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758874AbYEVMJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:09:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:57481 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756275AbYEVMJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:09:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+UHqVUyUWUAl7yDt7gsbtNoW2vsB0UBgKoQZnKHb
	1YGqa3/51mq0jM
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Greg Smith <gsmith@gregsmith.com>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1211456659.29104.20.camel@twins>
References: <Pine.GSO.4.64.0805211115390.8451@westnet.com>
	 <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
	 <1211456659.29104.20.camel@twins>
Content-Type: text/plain
Date: Thu, 22 May 2008 14:09:36 +0200
Message-Id: <1211458176.5693.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-22 at 13:44 +0200, Peter Zijlstra wrote:

> Humm,.. how to fix this.. we'd need to somehow detect the 1:n nature of
> its operation - I'm sure there are other scenarios that could benefit
> from this.

Maybe simple (minded): cache waker's last non-interrupt context wakee,
if the wakee != cached, ignore SYNC_WAKEUP unless sync was requested at
call time?

	-Mike

