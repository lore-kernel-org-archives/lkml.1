Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYFQAmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYFQAmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 20:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYFQAmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 20:42:23 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53368 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYFQAmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 20:42:22 -0400
Message-Id: <200806170042.m5H0gJAR051370@www262.sakura.ne.jp>
Subject: Re: [2.6.22? VMware?] BUG() at sysfs_follow_link+0x129/0x260
From: penguin-kernel@i-love.sakura.ne.jp
To: akataria@vmware.com
Cc: dhecht@vmware.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Jun 2008 09:42:19 +0900
References: <200806160337.m5G3blQp087139@www262.sakura.ne.jp> <1213658842.20705.36.camel@promb-2n-dhcp368.eng.vmware.com>
In-Reply-To: <1213658842.20705.36.camel@promb-2n-dhcp368.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alok Kataria wrote:
> Is this bug reproducible ?
Yes.

> Does this oops happen while the vmware-install script is still
> executing ?
It happened while /usr/bin/vmware-config-tools.pl is running.
I uploaded screenshots at the moment of oops.
http://I-love.SAKURA.ne.jp/tmp/oops-1.png
http://I-love.SAKURA.ne.jp/tmp/oops-2.png
http://I-love.SAKURA.ne.jp/tmp/oops-3.png

> Or does it happen after the installation/upgrade is complete ?
> If its the latter case, Can you please determine what line in the perl
> script is triggering this oops ?
The process who triggered this oops is "slabinfo".
So I tried "strace slabinfo" while I am running /usr/bin/vmware-config-tools.pl ,
and I found that the oops is happening while trying to read hgfsReqCache entry.
http://I-love.SAKURA.ne.jp/tmp/oops-4.png

Here is my environment:

 Host OS:

   CentOS 5.1 x86_64 on ThinkPad X60
   VMware workstation 6.0.4

 Guest OS:

   Ubuntu 7.10 i386
   Using NAT's DHCP for networking.

Regards.
