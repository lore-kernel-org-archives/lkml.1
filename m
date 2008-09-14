Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYINN2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYINN2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 09:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYINN16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 09:27:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58215 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbYINN16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 09:27:58 -0400
Date: Sun, 14 Sep 2008 15:27:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: arjan@linux.intel.com, tglx@linutronix.de, hpa@zytor.com,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Frans Pop <elendil@planet.nl>
Subject: Re: [patch 2/2] x86: Handle error returns in set_memory_*
Message-ID: <20080914132742.GB554@elte.hu>
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.970641000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080913000051.970641000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0174]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Correctly handle the error returns from set_memory_*. We have to free 
> memtype on error return path.

ah, so this is what caused the display artifacts reported by Frans Pop?

	Ingo
