Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbYDSKBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbYDSKBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 06:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYDSKAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 06:00:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36947 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbYDSKAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 06:00:53 -0400
Date: Sat, 19 Apr 2008 12:00:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on latest
	-git
Message-ID: <20080419100034.GA9475@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0639]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


randconfig testing found a netfilter build failure in latest -git:

  net/netfilter/nf_conntrack_sip.c: In function 'set_expected_rtp_rtcp':
  net/netfilter/nf_conntrack_sip.c:786: error: 'struct nf_conntrack_expect' has no member named 'saved_ip'

  http://redhat.com/~mingo/misc/config-Sat_Apr_19_11_37_02_CEST_2008.bad

disabling CONFIG_NF_CONNTRACK_SIP works it around.

btw., i found no thread to reply to on lkml or elsewhere - arent all git 
pull requests supposed to be Cc:-ed to lkml, with shortlog included?

	Ingo
