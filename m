Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbYDSN4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbYDSN4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 09:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbYDSN4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 09:56:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbYDSN4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 09:56:30 -0400
Date: Sat, 19 Apr 2008 15:56:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [built bug] drivers/net/wireless/iwlwifi/iwl-debugfs.c
Message-ID: <20080419135602.GA2499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0328]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


here's another networking (iwlwifi) related build failure with latest 
-git:

drivers/net/wireless/iwlwifi/iwl-debugfs.c: In function 'iwl_dbgfs_stations_read':
drivers/net/wireless/iwlwifi/iwl-debugfs.c:256: error: 'struct iwl4965_tid_data' has no member named 'agg'

  http://redhat.com/~mingo/misc/config-Sat_Apr_19_14_41_43_CEST_2008.bad

	Ingo
