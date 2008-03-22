Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYCVMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYCVMES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 08:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYCVMEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 08:04:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45610 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbYCVMEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 08:04:14 -0400
Date: Sat, 22 Mar 2008 13:04:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Message-ID: <20080322120400.GE13264@elte.hu>
References: <200803202358.33722.yhlu.kernel@gmail.com> <20080321120313.GD25225@elte.hu> <86802c440803211704u4fb07074w934f32d2f95bf6a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803211704u4fb07074w934f32d2f95bf6a7@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >  one structural observation: please make this unified functionality, 
> >  so that 32-bit kernels can make use of it too.
> 
> that will need to use PAE to switch 2G windows ....

well, please try some non-PAE, checks-direct-mappings approach - if 
someone wants to extend it to the highmem bits i'm sure it will be done.

	Ingo
