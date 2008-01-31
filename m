Return-Path: <linux-kernel-owner+w=401wt.eu-S1763625AbYAaPAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763625AbYAaPAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYAaPA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:00:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34140 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbYAaPA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:00:26 -0500
Date: Thu, 31 Jan 2008 16:00:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Patrick McHardy <kaber@trash.net>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [build bug] ip_queue.c:(.init.text+0x322c): undefined
	reference to `net_ipv4_ctl_path'
Message-ID: <20080131150008.GA9386@elte.hu>
References: <20080130164554.GA2800@elte.hu> <47A0BAB5.3080207@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A0BAB5.3080207@trash.net>
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


* Patrick McHardy <kaber@trash.net> wrote:

>> config attached.
>
> Thanks, the reason is CONFIG_SYSCTL=n. I've queued this patch (might 
> not apply to Linus' tree due to local changes) to fix the build error 
> and a runtime error with CONFIG_PROC_FS=n.

it applied fine here and it resolved the build problem. Thanks,

	Ingo
