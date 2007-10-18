Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbXJRU7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbXJRU7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbXJRU6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:58:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60791 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846AbXJRU6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:58:52 -0400
Message-ID: <4717C90A.4060208@garzik.org>
Date: Thu, 18 Oct 2007 16:58:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Erez Zadok <ezk@cs.sunysb.edu>
CC: linux-kernel@vger.kernel.org, pcnet32@verizon.net, netdev@vger.kernel.org
Subject: Re: broken PCNET32 in 2.6.24 requires experimental PCNET32_NAPI?
References: <200710182054.l9IKsiQJ007446@agora.fsl.cs.sunysb.edu>
In-Reply-To: <200710182054.l9IKsiQJ007446@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok wrote:
> I'm using Linus's git tree as of commit
> d85714d81cc0408daddb68c10f7fd69eafe7c213.  I built that kernel under vmware
> workstation 6.0.1 which emulates a pcnet32 nic.  When I only turn on
> CONFIG_PCNET32, my network interface doesn't seem to come up fully: my dhcp
> server sees a request, offers an IP addr, but the VM running 2.6.24 doesn't
> pick up the response.  Manually configuring the eth0 and pinging yields
> similar results: no replies come back.  The same VM has lots of other
> kernels on it, all of which work fine (so it's not an iptables/selinux
> problem, or the like).
> 
> If, however, I turn on the EXPERIMENTAL feature CONFIG_PCNET32_NAPI, then
> the driver works again.  So, is this NAPI feature now a required one or did
> the base driver somehow got broken?  I've not investigated this further.

Fixes were posted by the maintainer, and pushed to Linus, yesterday...

	Jeff



