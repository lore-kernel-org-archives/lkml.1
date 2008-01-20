Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbYATUBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbYATUBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbYATUB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:01:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbYATUB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:01:26 -0500
Date: Sun, 20 Jan 2008 21:01:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24 regression: reference count leak in PPPoE
Message-ID: <20080120200109.GA31876@elte.hu>
References: <200801202053.30386.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801202053.30386.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> My workstation running 2.6.24-rc8 just hung during shutdown with an 
> endless (or rather I didn't wait more than a few minutes) loop of
> 
> unregister_netdev: waiting for ppp-device to become free. Usage count 
> = 1
> 
> ppp-device was an active PPPoE device.
> 
> No more information currently.

i've seen such problems (locked up box with endless loop of usage count 
== 1) with pppoe in the past, and it seemed to be related to dynamic 
IPs. (i saw that well before 2.6.24 - reported it once to davem)

It seems to have stopped when i stopped using ipsec and started using 
vpnc. (but no firm info - this was sporadic - happened every few months 
or so) Are you using ipsec and dynamic IPs by any chance?

	Ingo
