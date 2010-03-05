Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0CETP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:15:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44087 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab0CETP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:15:57 -0500
Subject: Re: [PATCH 3/5] perf, x86: Disable PEBS on clowertown chips
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <bd4cb8901003051058k5c3d88bewa787f88f03d2da80@mail.gmail.com>
References: <20100305153926.639506880@chello.nl>
	 <20100305154128.890278662@chello.nl>
	 <bd4cb8901003051058k5c3d88bewa787f88f03d2da80@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 20:15:53 +0100
Message-ID: <1267816553.4942.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 10:58 -0800, Stephane Eranian wrote:
> >        case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
> > +               x86_pmu.quirks = intel_clowertown_quirks;
> 
> That's too coarse grain!
> It is more subtle than this. Some of the errata are marked as Plan
> fix. They seem to be
> fixed in later models. Your looking at the E5xxx series errata but the
> E7xxx do not have
> the same problems. 

OK, I'll look at those errata again and try to come up with a stepping
test for this errata.

