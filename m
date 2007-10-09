Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbXJIQia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbXJIQia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 12:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbXJIQiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 12:38:22 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:29214 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752574AbXJIQiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 12:38:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=1di/TjlUGAjaGR2JFA6GNOsRJ+5qK6g4rfHTo6XJ0wwsVwxEj1nooixcooV2XV8xICo9xf517rJxyGFqugJDomYlDVD5bFQMu/oDOsV5r+WeP4+qcQgPJhnqnGnR51iyhg2di1o6QVi2zEDrzr69iplLucf3hEgCQu3CyGEEkgs=  ;
X-YMail-OSG: NXFcblMVM1mQ_Fgr0imVY5ImOIwaz4lrW.enBbl7hqKRFluJ2Ru_P02VTFmErMpHO7sn_lsI.g--
Date: Tue, 09 Oct 2007 09:38:27 -0700
From: David Brownell <david-b@pacbell.net>
To: davem@davemloft.net
Subject: Re: OHCI root_port_reset() deadly loop...
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com
References: <20071007.005156.85395415.davem@davemloft.net>
 <20071008.165420.42793456.davem@davemloft.net>
 <20071009043643.773CC23715F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071008.214408.98397070.davem@davemloft.net>
In-Reply-To: <20071008.214408.98397070.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071009163827.E7DB310B535@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > What values do you see for "portstat"?
>
> 0x111

That's unfortunately useless ... PPS, PRS, CCS (meaning powered,
resetting, connected).  In short, there is *no* indication from
the OHCI hardware that a disconnect happened.

