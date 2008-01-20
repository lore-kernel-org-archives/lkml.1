Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbYATJNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbYATJNh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 04:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYATJN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 04:13:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYATJNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 04:13:25 -0500
Date: Sun, 20 Jan 2008 10:13:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc8-git does not boot on Geode LX
Message-ID: <20080120091315.GA8379@elte.hu>
References: <20080120081442.GA12713@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080120081442.GA12713@1wt.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1036]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> Checking 'hlt' instruction... OK.                                               
> Freeing SMP alternatives: 0k freed                                              
> net_namespace: 64 bytes                                                         
> NET: Registered protocol family 16                                              
> -----> hangs here <-----

just a hint: this is near the first piece of code that makes active use 
of a timer wakeup, on a typical x86 bootup. So sometimes if timers are 
not working at all, hangs happen around here. But the PCI related thing 
you suspect could be the reason too. Getting a SysRq-T or an NMI 
printout (if that's possible) of the hung site would be nice.

	Ingo
