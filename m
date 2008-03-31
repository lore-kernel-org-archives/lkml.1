Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYCaMg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYCaMg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbYCaMgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:36:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57798 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbYCaMgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:36:18 -0400
Date: Mon, 31 Mar 2008 14:35:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RFC] Add default CPU topology information
Message-ID: <20080331123557.GB14636@elte.hu>
References: <20080331114412.GH21637@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331114412.GH21637@solarflare.com>
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


* Ben Hutchings <bhutchings@solarflare.com> wrote:

> Not all architectures and configurations define CPU topology information.
> This can result in an empty topology directory in sysfs, and requires
> in-kernel users to protect all uses with #ifdef - see
> <http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.
> 
> The documentation of CPU topology specifies what the defaults should be
> if only partial information is available from the hardware.  So we can
> provide these defaults as a fallback.
> 
> This patch:
> 
> - Adds default definitions of the 4 topology macros to
>   include/asm-generic/topology.h.
> - Changes include/asm-*/topology.h to include <asm-generic/topology.h>
>   unconditionally.
> - Changes drivers/base/topology.c to use the topology macros unconditionally
>   and to cope with definitions that aren't lvalues.
> - Updates documentation accordingly.
> 
> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>

very nice - i suspect this would be a patch for -mm.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
