Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbYFMFRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbYFMFRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 01:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYFMFRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 01:17:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43457 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbYFMFRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 01:17:07 -0400
Date: Fri, 13 Jun 2008 07:16:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] cputopology: Always define CPU topology information
	[5th try]
Message-ID: <20080613051654.GC21586@elte.hu>
References: <20080604154454.GD11300@solarflare.com> <20080604214715.bbebe325.akpm@linux-foundation.org> <20080605120829.GI11300@solarflare.com> <20080605092831.a77d164d.akpm@linux-foundation.org> <20080605163714.GO11300@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605163714.GO11300@solarflare.com>
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


* Ben Hutchings <bhutchings@solarflare.com> wrote:

> Not all architectures and configurations define CPU topology 
> information. This can result in an empty topology directory in sysfs, 
> and requires in-kernel users to protect all uses with #ifdef - see 
> <http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.
> 
> The documentation of CPU topology specifies what the defaults should 
> be if only partial information is available from the hardware.  So we 
> can provide these defaults as a fallback.
> 
> This patch:
> 
> - Adds default definitions of the 4 topology macros to <linux/topology.h>
> - Changes drivers/base/topology.c to use the topology macros unconditionally
> - Updates documentation accordingly

applied to tip/core/topology - thanks Ben.

	Ingo
