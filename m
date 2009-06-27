Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZF0Iep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZF0Iep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 04:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZF0Ieg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 04:34:36 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:59825 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbZF0Ieg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 04:34:36 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/2] perf_counter: powerpc: Add callchain support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <19013.44722.893263.275594@cargo.ozlabs.ibm.com>
References: <19013.44646.549261.100582@cargo.ozlabs.ibm.com>
	 <19013.44722.893263.275594@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 10:34:44 +0200
Message-Id: <1246091684.31755.210.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 15:31 +1000, Paul Mackerras wrote:
> +       if (regs) {
> +               if (current_is_64bit())
> +                       perf_callchain_user_64(regs, entry);
> +               else
> +                       perf_callchain_user_32(regs, entry);
> +       }

Ingo do we need 32 on 64 stuff like that too?

