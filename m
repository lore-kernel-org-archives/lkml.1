Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYDXGLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYDXGLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 02:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYDXGKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 02:10:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34762
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbYDXGKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 02:10:54 -0400
Date: Wed, 23 Apr 2008 23:10:55 -0700 (PDT)
Message-Id: <20080423.231055.193687131.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: gordonfarquharson@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       netdev@vger.kernel.org
Subject: Re: physmap and "request_module: runaway loop modprobe net-pf-1"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209016143.9212.910.camel@pmac.infradead.org>
References: <1208867831.9212.582.camel@pmac.infradead.org>
	<97a0a9ac0804232101i71bfff22o723e2aaa80b09c2f@mail.gmail.com>
	<1209016143.9212.910.camel@pmac.infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Thu, 24 Apr 2008 06:49:03 +0100

> On Wed, 2008-04-23 at 22:01 -0600, Gordon Farquharson wrote:
> > I guess the question is which patch (if either) is more appealing.
> 
> I definitely think we should initialise AF_UNIX sockets earlier. At
> least request_module() _can_ work then, if you want it to and you set up
> userspace accordingly.

I'm not so sure, for example, what if AF_UNIX is built modular?
