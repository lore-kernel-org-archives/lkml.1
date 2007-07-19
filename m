Return-Path: <linux-kernel-owner+w=401wt.eu-S1762198AbXGSMb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198AbXGSMb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbXGSMbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:31:22 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:53408 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbXGSMbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:31:21 -0400
Message-ID: <469F5941.7090900@googlemail.com>
Date: Thu, 19 Jul 2007 14:29:53 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: netdev@vger.kernel.org
Subject: net/ipv4/inetpeer.c stack warnings
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ,

I noticed on current git this warning in net/ipv4/inetpeer.c

...

  CC      net/ipv4/inetpeer.o
net/ipv4/inetpeer.c: In function 'unlink_from_pool':
net/ipv4/inetpeer.c:297: warning: the address of 'stack' will always
evaluate as 'true'
net/ipv4/inetpeer.c:297: warning: the address of 'stack' will always
evaluate as 'true'
net/ipv4/inetpeer.c: In function 'inet_getpeer':
net/ipv4/inetpeer.c:409: warning: the address of 'stack' will always
evaluate as 'true'
net/ipv4/inetpeer.c:409: warning: the address of 'stack' will always
evaluate as 'true'


...

Regards,

Gabriel C
