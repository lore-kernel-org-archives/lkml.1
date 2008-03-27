Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbYC0JKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbYC0JKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbYC0JJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:09:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35326 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597AbYC0JJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:09:45 -0400
Date: Thu, 27 Mar 2008 10:09:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: ying.huang@intel.com, hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/4] x86_64 boot: Add linked listof struct
	setup_data to boot protocol
Message-ID: <20080327090925.GC30918@elte.hu>
References: <1206601743.3067.20.camel@caritas-dev.intel.com> <20080327083221.GD15626@elte.hu> <20080327040216.99dcde7b.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327040216.99dcde7b.pj@sgi.com>
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


* Paul Jackson <pj@sgi.com> wrote:

> In the file arch/x86/boot/main.c, see the line:
> 
>     BUILD_BUG_ON(sizeof boot_params != 4096);

oh well, indeed. I was hoping for some simple short-term solution as 
well that could go into 2.6.25.

( in case anyone knows about any other stupidly shortsighted limit we 
  have in arch/x86 that is not being worked on yet, please tell us 
  _before_ we hit it with real hardware ... )

	Ingo
