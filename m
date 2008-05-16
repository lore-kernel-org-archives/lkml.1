Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbYEPLPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbYEPLPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 07:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYEPLOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 07:14:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbYEPLOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 07:14:52 -0400
Date: Fri, 16 May 2008 13:14:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix crash on cpu hotplug on pat-incapable machines
Message-ID: <20080516111434.GA2065@elte.hu>
References: <1210756832-31749-1-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210756832-31749-1-git-send-email-avi@qumranet.com>
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


* Avi Kivity <avi@qumranet.com> wrote:

> pat_disable() is __init, which means it goes away after booting is 
> complete. Unfortunately it is used by the hotplug code if the machine 
> is not pat-capable, causing a crash.
> 
> Fix by marking pat_disable() as __cpuinit.

applied, thanks Avi.

	Ingo
