Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYDSIQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYDSIQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 04:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYDSIQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 04:16:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35499 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbYDSIQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 04:16:38 -0400
Date: Sat, 19 Apr 2008 10:16:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull infiniband.git
Message-ID: <20080419081614.GA2437@elte.hu>
References: <adaskxkh6s2.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaskxkh6s2.fsf@cisco.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland Dreier <rdreier@cisco.com> wrote:

>       IB/ipath: Misc changes to prepare for IB7220 introduction

>       IB/ipath: add calls to new 7220 code and enable in build

x86.git auto-testing found that these changes broke the -git build, with 
this config:

  http://redhat.com/~mingo/misc/config-Sat_Apr_19_09_55_05_CEST_2008.bad

the failure is a link failure:

 drivers/built-in.o: In function `ipath_init_one':
 ipath_driver.c:(.devinit.text+0x1e5bc): undefined reference to `ipath_init_iba7220_funcs'

disabling CONFIG_INFINIBAND_IPATH=y works this around.

	Ingo
