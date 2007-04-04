Return-Path: <linux-kernel-owner+w=401wt.eu-S966232AbXDDBdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966232AbXDDBdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966242AbXDDBdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:33:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:52681 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966232AbXDDBdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:33:44 -0400
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, flar@allandria.com, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070403.181733.27782389.davem@davemloft.net>
References: <20070403.170212.02298297.davem@davemloft.net>
	 <1175645568.10567.42.camel@shinybook.infradead.org>
	 <1175649192.30879.19.camel@localhost.localdomain>
	 <20070403.181733.27782389.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 11:32:42 +1000
Message-Id: <1175650362.30879.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 18:17 -0700, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Wed, 04 Apr 2007 11:13:12 +1000
> 
> > It worked before the new serial core, we had a "tweak" in the old 8250
> > driver to be able to share minors, but that got busted when Russell
> > rewrote the whole thing. I remember asking him back when he still was
> > the serial maintainer, and he refused to bring back some sharing of
> > minors.
> 
> Fork the 8250 driver like I did on Sparc so you can get the
> dynamic minor behavior back :-))))

heh, maybe I can use your forked/sparc version :-)

Ben.


