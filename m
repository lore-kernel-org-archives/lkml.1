Return-Path: <linux-kernel-owner+w=401wt.eu-S1762908AbXJRUyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762908AbXJRUyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbXJRUyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:54:47 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33287 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbXJRUyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:54:46 -0400
Date: Thu, 18 Oct 2007 16:54:44 -0400
Message-Id: <200710182054.l9IKsiQJ007446@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, pcnet32@verizon.net
CC: netdev@vger.kernel.org
Subject: broken PCNET32 in 2.6.24 requires experimental PCNET32_NAPI?
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using Linus's git tree as of commit
d85714d81cc0408daddb68c10f7fd69eafe7c213.  I built that kernel under vmware
workstation 6.0.1 which emulates a pcnet32 nic.  When I only turn on
CONFIG_PCNET32, my network interface doesn't seem to come up fully: my dhcp
server sees a request, offers an IP addr, but the VM running 2.6.24 doesn't
pick up the response.  Manually configuring the eth0 and pinging yields
similar results: no replies come back.  The same VM has lots of other
kernels on it, all of which work fine (so it's not an iptables/selinux
problem, or the like).

If, however, I turn on the EXPERIMENTAL feature CONFIG_PCNET32_NAPI, then
the driver works again.  So, is this NAPI feature now a required one or did
the base driver somehow got broken?  I've not investigated this further.

Cheers,
Erez.
