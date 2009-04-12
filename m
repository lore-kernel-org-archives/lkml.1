Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZDLNvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZDLNvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 09:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZDLNv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 09:51:27 -0400
Received: from vienpom.coecu.nl ([82.94.165.232]:50539 "EHLO vienpom.coecu.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZDLNv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 09:51:27 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Apr 2009 09:51:26 EDT
MIME-Version: 1.0
Date: Sun, 12 Apr 2009 15:45:51 +0200
From: =?UTF-8?Q?M=C3=B4she_van_der_Sterre?= <me@moshe.nl>
To: containers@lists.osdl.org, lxc-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: BUG in tty_open when using containers and ptrace
Message-ID: <d06d0dd6a4ddf760bea53291c048e291@[::1]>
User-Agent: RoundCube Webmail/0.2-beta
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am working on the lxc userspace tools, and got this BUG a couple of
times.
Here are the reports:

http://moshe.nl/tty-bugshot1.png
http://moshe.nl/tty-bugshot2.png

I am running 2.6.29.1 from kernel.org in a virtual machine under kvm.
I have not been able to reliably reproduce it, but it happens only after
the container is setup and ptrace is active on lxc-start.
I think the first screen shot is while all ttys where allowed in
cgroup.devices, the second one while only tty1 was allowed.

Greetings,
Môshe van der Sterre
