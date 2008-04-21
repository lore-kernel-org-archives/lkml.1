Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbYDUGXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbYDUGXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 02:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYDUGXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 02:23:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60928 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbYDUGXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 02:23:34 -0400
Date: Mon, 21 Apr 2008 08:22:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       Mohamed Abbas <mabbas@linux.intel.com>, Ian Schram <ischram@telenet.be>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [build bug] nf_nat_proto_sctp.c:(.text+0x6d173): undefined
	reference to `crc32c_le'
Message-ID: <20080421062244.GA862@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> and after i restarted last night's QA run, within a few iterations a 
> fourth build failure popped up:

and here's a fifth build failure in the networking code, triggered in 
our testing:

  net/built-in.o: In function `sctp_manip_pkt':
  nf_nat_proto_sctp.c:(.text+0x6d173): undefined reference to `crc32c_le'
  nf_nat_proto_sctp.c:(.text+0x6d180): undefined reference to `crc32c_le'
  nf_nat_proto_sctp.c:(.text+0x6d196): undefined reference to `crc32c_le'
  nf_nat_proto_sctp.c:(.text+0x6d1c6): undefined reference to `crc32c_le'

  http://redhat.com/~mingo/misc/config-Mon_Apr_21_01_52_14_CEST_2008.bad

	Ingo
