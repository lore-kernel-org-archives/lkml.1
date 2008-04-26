Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbYDZORt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbYDZORt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbYDZORe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:17:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59413 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523AbYDZORd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:17:33 -0400
Date: Sat, 26 Apr 2008 16:17:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, arjan@linux.intel.com,
       Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH] x86: create array based interface to chagne page
	attribute
Message-ID: <20080426141718.GA10936@elte.hu>
References: <1209202037-6513-1-git-send-email-airlied@redhat.com> <20080426095115.GA15212@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426095115.GA15212@elte.hu>
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


x86.git qa found a boot crash caused by this patch, see:

[    0.120007] CPU: Processor Core ID: 0
[    0.124007] ACPI: Core revision 20070126
[    0.128008] BUG: unable to handle kernel paging request at fffffffb80d6fe30
[    0.128008] IP: [<ffffffff802200a3>] __change_page_attr_set_clr+0x6c/0xaf7
[    0.128008] PGD 203067 PUD 0
[    0.128008] Thread overran stack or stack corrupted

  http://redhat.com/~mingo/misc/log-Sat_Apr_26_15_47_59_CEST_2008.bad
  http://redhat.com/~mingo/misc/config-Sat_Apr_26_15_47_59_CEST_2008.bad

	Ingo
