Return-Path: <linux-kernel-owner+w=401wt.eu-S935769AbYD1SNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935769AbYD1SNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934937AbYD1SNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:13:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46145 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934914AbYD1SNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:13:13 -0400
Date: Mon, 28 Apr 2008 20:12:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@linux.ie>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH] x86: create array based interface to chagne page
	attribute
Message-ID: <20080428181257.GA2242@elte.hu>
References: <1209202037-6513-1-git-send-email-airlied@redhat.com> <20080426095115.GA15212@elte.hu> <20080426141718.GA10936@elte.hu> <alpine.DEB.0.82.0804262323520.26860@skynet.skynet.ie> <20080428134759.GE3973@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428134759.GE3973@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Dave Airlie <airlied@linux.ie> wrote:
> 
> > one-liner attached.
> 
> applied, thanks.

x86.git randconfig boot testing found hard lockups and crashes. Bisected 
it down to your patch. Config and crashlog at:

  http://redhat.com/~mingo/misc/log-Mon_Apr_28_20_00_50_CEST_2008.bad
  http://redhat.com/~mingo/misc/config-Mon_Apr_28_20_00_50_CEST_2008.bad

(can send more info if you need it.)

	Ingo
