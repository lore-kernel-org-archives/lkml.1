Return-Path: <linux-kernel-owner+w=401wt.eu-S964800AbXBLJJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800AbXBLJJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964802AbXBLJJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:09:01 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:50405 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076AbXBLJIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:08:50 -0500
X-Greylist: delayed 3501 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 04:08:48 EST
Date: Mon, 12 Feb 2007 01:37:38 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 00/10] nfnetlink_log: patch series introduction
Message-ID: <20070212003738.GA8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

After meeting a faint-hearted Linux kernel lately I decided to try myself
at persuading it to not be afraid of NFLOG. This chat gave a series of
ten commandments I present today. Take a look and agree or comment.

Here's the list:

  1. nfulnl_log_packet() - don't count the same thing twice
* 2. nfulnl_log_packet() - don't leak references
  3. nfulnl_log_packet() - don't copy-and-paste code
* 4. nfulnl_timer() - don't touch freed memory
  5. nfulnl_recv_config() - don't free what isn't there
  6. nfulnl_recv_config() - don't touch dead animals
* 7. instance_destroy() - remember of your appointments
  8. instance_create() - don't lock the bookshelf for too long
! 9. __build_packet_message() - don't forget your tail
 10. instance_create() - wear your watch when going out

Ninth is THE one. Those marked with stars are important I believe.
Others came out on the way. I'll send them one-in-a-mail right after
this message. I'm CC:ing this to LKML, so someone could put the important
ones in -stable maybe?

Have a nice reading,
Michal Miroslaw

PS. Please CC: me if you need my answer as I read the list's archive
only and I am not subscribed.

