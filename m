Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbYDTHfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbYDTHfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 03:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYDTHfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 03:35:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48603 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbYDTHfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 03:35:15 -0400
Date: Sun, 20 Apr 2008 09:34:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       Mohamed Abbas <mabbas@linux.intel.com>, Ian Schram <ischram@telenet.be>,
       Tomas Winkler <tomas.winkler@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [build bug] iwl-3945-led.c:(.text+0x119e36): undefined reference
	to `__led_classdev_unregister'
Message-ID: <20080420073441.GA31745@elte.hu>
References: <20080419135602.GA2499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080419135602.GA2499@elte.hu>
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


> here's another networking (iwlwifi) related build failure with latest 
> -git:

a third -git build failure triggered in last night's x86.git build/boot 
testing:

 drivers/built-in.o: In function `iwl3945_led_unregister_led':
  iwl-3945-led.c:(.text+0x119e36): undefined reference to `__led_classdev_unregister'
 drivers/built-in.o: In function `iwl3945_led_register_led':
  iwl-3945-led.c:(.text+0x119ecd): undefined reference to `led_classdev_register'

config:

 http://redhat.com/~mingo/misc/config-Sat_Apr_19_22_08_04_CEST_2008.bad

probably due to commit ab53d8af6 "iwlwifi: Add led support".

	Ingo
