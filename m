Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYIHR4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYIHR4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYIHR4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:56:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50517 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbYIHR4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:56:14 -0400
Date: Mon, 8 Sep 2008 19:55:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [RFC 0/4] Using HPET in MSI mode and setting up per CPU HPET
	timers
Message-ID: <20080908175554.GA24987@elte.hu>
References: <20080906010214.229910000@intel.com> <20080906124234.GG30964@elte.hu> <20080906130353.GA30340@elte.hu> <20080908171840.GA31009@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908171840.GA31009@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> There was one code path, with CONFIG_PCI_MSI disabled, where we were 
> accessing hpet_devs without initialization. That resulted in the above 
> crash. The change below adds a check for hpet_devs.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

applied to tip/timers/hpet-percpu, thanks Venki!

	Ingo
