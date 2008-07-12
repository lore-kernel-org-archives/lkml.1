Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYGLGqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYGLGqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 02:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYGLGqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 02:46:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46399 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbYGLGqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 02:46:12 -0400
Date: Sat, 12 Jul 2008 08:45:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
	x2apic support
Message-ID: <20080712064548.GA27260@elte.hu>
References: <20080710215617.GM1678@linux-os.sc.intel.com> <20080711102814.GA17938@elte.hu> <20080711200957.GA8173@elte.hu> <20080711203151.GU1678@linux-os.sc.intel.com> <86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com> <20080711204521.GA15689@elte.hu> <20080711212418.GV1678@linux-os.sc.intel.com> <86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com> <20080712053713.GA341@elte.hu> <86802c440807112306h6b396cd3ycf6bf490d6c2ccf9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807112306h6b396cd3ycf6bf490d6c2ccf9@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > other patches, to make it all bisectable.
> 
> should incorperate that fix into the patch that introduce new 
> read_apic_id()
> 
> commit df8cc50cc9357ba5a5d6a07744fa36b16a81121c
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Thu Jul 10 11:16:48 2008 -0700
> 
>     x64, x2apic/intr-remap: introduce read_apic_id() to genapic routines
> 
>     Move the read_apic_id()  to genapic routines.

ok, i've moved it straight after that commit. (bisecting hitting exactly 
that window is not an issue and it's better if we see in the history the 
types of breakages certain changes can cause - that helps people who 
research yet-unfixed crashes, etc.)

	Ingo
