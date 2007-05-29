Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbXE2Wxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbXE2Wxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbXE2WxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:53:21 -0400
Received: from www.osadl.org ([213.239.205.134]:40272 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751455AbXE2WxU (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:53:20 -0400
Subject: Re: [BUG] Something goes wrong with timer statistics.
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
Cc: iank@bredband.net, Linux-kernel@vger.kernel.org, mingo@elte.hu,
       arjan@infradead.org
In-Reply-To: <20070529.154428.11609556.davem@davemloft.net>
References: <1180474738.22497.25.camel@pi.pomac.com>
	 <20070529.153723.108751260.davem@davemloft.net>
	 <1180478532.20546.41.camel@chaos>
	 <20070529.154428.11609556.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 30 May 2007 00:53:16 +0200
Message-Id: <1180479196.20546.46.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 15:44 -0700, David Miller wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 30 May 2007 00:42:12 +0200
> 
> > On Tue, 2007-05-29 at 15:37 -0700, David Miller wrote:
> > > I see this same exact problem on sparc64.
> > 
> > 100% reproducible ?
> 
> I think so, I'll try to find time to tinker with it a bit
> more.

It seems to be a subtle bug in the timer stats code, but I did not spot
it.

	tglx


