Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbXCaK32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbXCaK32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 06:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbXCaK32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 06:29:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:54946 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752797AbXCaK31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 06:29:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+mOtofaG+mert1RswGx910Qhb6iHG7xqQNOkP4Rm
	89coZldfaXDLvw
Subject: Re: [BUG] scheduler: strange behavor with massive
	interactive	processes
From: Mike Galbraith <efault@gmx.de>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <87wt0xhg7i.wl%takeuchi_satoru@jp.fujitsu.com>
References: <87r6rb1nbm.wl%takeuchi_satoru@jp.fujitsu.com>
	 <1174971852.16403.35.camel@Homer.simpson.net>
	 <1175071091.29829.58.camel@Homer.simpson.net>
	 <87wt0xhg7i.wl%takeuchi_satoru@jp.fujitsu.com>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 12:29:24 +0200
Message-Id: <1175336964.6869.32.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-31 at 19:15 +0900, Satoru Takeuchi wrote:

> It seems to highly depend on # of processes and at present, Ingo's patch
> looks better.

Yeah, Ingo's patch forces the array switch where I try to avoid it if at
all possible.  I'm looking ways to know for sure that you just have to
bite that bullet.

Thanks for testing.

	-Mike

