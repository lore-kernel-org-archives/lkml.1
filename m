Return-Path: <linux-kernel-owner+w=401wt.eu-S965351AbXBFF4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351AbXBFF4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 00:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965361AbXBFF4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 00:56:21 -0500
Received: from outbound4.mail.tds.net ([216.170.230.94]:35482 "EHLO
	outbound4.mail.tds.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965344AbXBFF4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 00:56:19 -0500
X-Greylist: delayed 44285 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Feb 2007 00:56:19 EST
Subject: Re: [take35 0/10] kevent: Generic event handling mechanism.
From: "David M. Lloyd" <dmlloyd@flurg.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: David Miller <davem@davemloft.net>, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@osdl.org>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       netdev <netdev@vger.kernel.org>, Zach Brown <zach.brown@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Chase Venters <chase.venters@clientec.com>,
       Johann Borck <johann.borck@densedata.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Jamal Hadi Salim <hadi@cyberus.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org
In-Reply-To: <11703247503374@2ka.mipt.ru>
References: <11703247503374@2ka.mipt.ru>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 11:28:05 -0600
Message-Id: <1170696485.22199.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 13:12 +0300, Evgeniy Polyakov wrote:
> Generic event handling mechanism.

The patch applied cleanly to 2.6.20 final, but I got a build error:

  CC      kernel/kevent/kevent.o
  CC      kernel/kevent/kevent_user.o
  CC      kernel/kevent/kevent_timer.o
  CC      kernel/kevent/kevent_poll.o
make[2]: *** No rule to make target `kernel/kevent/epoll.o', needed by `kernel/kevent/built-in.o'.  Stop.
make[1]: *** [kernel/kevent] Error 2
make: *** [kernel] Error 2

- DML

