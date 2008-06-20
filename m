Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbYFTPht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbYFTPht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760675AbYFTPhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:37:37 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63719 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760667AbYFTPhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:37:36 -0400
Date: Fri, 20 Jun 2008 16:36:51 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: check command line when CONFIG_X86_MPPARSE is not
 set
In-Reply-To: <20080620150151.GA17373@elte.hu>
Message-ID: <Pine.LNX.4.55.0806201636070.19614@cliff.in.clinika.pl>
References: <200805041823.57198.yhlu.kernel@gmail.com>
 <200806191213.10312.yhlu.kernel@gmail.com> <200806191215.01538.yhlu.kernel@gmail.com>
 <200806200742.36226.yhlu.kernel@gmail.com> <20080620150151.GA17373@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008, Ingo Molnar wrote:

> hm, i think instead of a panic() we should print a warning and fall back 
> to nosmp - an UP bootup should work just fine without any mptable 
> information.

 It sounds reasonable to me as well.

  Maciej
