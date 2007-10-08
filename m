Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbXJHNV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbXJHNV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 09:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbXJHNVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 09:21:20 -0400
Received: from main.gmane.org ([80.91.229.2]:48684 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbXJHNVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 09:21:19 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bs@q-leap.de>
Subject: Re: 2.6.23 regression: do_nanosleep will not return
Date: Mon, 08 Oct 2007 15:20:26 +0200
Organization: q-leap networks GmbH
Message-ID: <fedaqr$njj$1@sea.gmane.org>
References: <fed93g$eq4$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: ns1.q-leap.de
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schubert wrote:

> Hi,
> 
> we have a system here were e.g. "sleep 1" will never finish. This is an
> issue of 2.6.23, on all older kernel versions it did work fine.
> 
> Seems to hang in do_nanosleep()
> 


Update: Enabling hpet in the bios and setting clocksource=hpet as command
line parameter will fix it, but still its not nice that something that
worked without a problem in 2.6.22 and below suddenly doesn't work in
2.6.23.


Bernd

