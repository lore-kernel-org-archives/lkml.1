Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYADHmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYADHmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 02:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYADHmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 02:42:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51808 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbYADHmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 02:42:14 -0500
Date: Fri, 4 Jan 2008 08:41:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, olof@lixom.net,
       mpm@selenic.com
Subject: Re: [patch 1/2] move WARN_ON() out of line
Message-ID: <20080104074149.GC17447@elte.hu>
References: <477D52ED.7000403@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477D52ED.7000403@linux.intel.com>
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> This patch build on top of Olof's patch that introduces __WARN, and 
> places the slowpath out of line. It also uses Ingo's suggestion to not 
> use __FUNCTION__ but to use kallsyms to do the lookup; this saves a 
> ton of extra space since gcc doesn't need to store the function string 
> twice now:
>
> 3936367  833603  624736 5394706  525112 vmlinux.before
> 3917508  833603  624736 5375847  520767 vmlinux-slowpath
>
> 15Kb savings...

hey, cool!

Acked-by: Ingo Molnar <mingo@elte.hu>

i'm wondering how we could put this into x86.git to get it tested some 
more. Olof's patch touches other architectures so it's not really 
appropriate. Maybe a portion of Olof's patch could be applied to make 
your patch apply cleanly?

	Ingo
