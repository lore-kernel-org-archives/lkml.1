Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbXJIGh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbXJIGh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXJIGhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:37:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:60440 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbXJIGhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:37:18 -0400
Subject: Re: OHCI root_port_reset() deadly loop...
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: david-b@pacbell.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, greg@kroah.com
In-Reply-To: <20071008.222622.22041332.davem@davemloft.net>
References: <20071008.165420.42793456.davem@davemloft.net>
	 <20071009040917.DC7FC237446@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <1191906816.6355.62.camel@pasglop>
	 <20071008.222622.22041332.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 16:37:08 +1000
Message-Id: <1191911828.6355.64.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-08 at 22:26 -0700, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Tue, 09 Oct 2007 15:13:36 +1000
> 
> > I'm not even sure module load order is 100% fault proof here since
> > khubd spawns as a thread...
> 
> I'm concerned about that as well, thanks for bringing it up.
> 
> My understanding, however, is that the critical thing is that the EHCI
> device reset being done by the EHCI driver probe occurs and completes
> first.  If that is true, then just making sure EHCI loads initially is
> a sufficient constraint to fix this problem.

Yup, that would be, though I hate that sort of load order
dependencies...

Ben.


