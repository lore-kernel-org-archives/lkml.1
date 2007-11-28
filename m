Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbXK1Mik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbXK1Mik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbXK1Mic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:38:32 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42558 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751586AbXK1Mib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:38:31 -0500
Date: Wed, 28 Nov 2007 06:38:23 -0600
From: Robin Holt <holt@sgi.com>
To: Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>,
       Kawai@americas.sgi.com, Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bron Nelson <bron@sgi.com>, Stephen Champion <schamp@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Can we make application core dumps interruptible?
Message-ID: <20071128123823.GB919@lnx-holt.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We have a customer machine with 4096 cpus.  When some user applications
crash, it begins dumping core and can tie up the filesystem and
processors for a considerable period of time.  Often, they contact the
user and the user says the core dump files will not be useful and they
reboot the machine.  They have already reduced the default core dump size
to not dump anything and taken all reasonable steps to limiting core dumps
while still allowing them to be useful for those users that need them.
They would like to not need to reboot.

They hoped for a couple changes, one of which is a way for a SIGTERM,
SIGKILL, or something along that line interrupting the core dump process.
Is this the correct direction to take?  Are there any better ideas for
handling this?

Thanks,
Robin Holt
