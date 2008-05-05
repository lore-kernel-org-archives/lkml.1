Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbYEEXuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbYEEXuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYEEXuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:50:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35906 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbYEEXt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:49:59 -0400
Date: Tue, 6 May 2008 01:49:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Rufus & Azrael <rufus-azrael@numericable.fr>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with xf86MapVidMem
	error
Message-ID: <20080505234938.GB11433@elte.hu>
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com> <481F87F2.70005@numericable.fr> <20080505232536.GA28026@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505232536.GA28026@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0597]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Which seems to be mapping framebuffer successfully.
> 
> Can you please try the patch below and capture the dmesg after you get 
> the above xf86MapVidMem error and send it. That should give us more 
> information on the failure.

> +#define	DEBUG

btw., could we turn this into a /debug or sysctl flag thing, to make it 
easier for people to get these debug messages?

	Ingo
