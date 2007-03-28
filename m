Return-Path: <linux-kernel-owner+w=401wt.eu-S965692AbXC1TKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692AbXC1TKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965695AbXC1TJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:09:00 -0400
Received: from mx1.suse.de ([195.135.220.2]:45128 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965694AbXC1TIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:08:42 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Simplify smp_call_function*() by using common implementation
Date: Wed, 28 Mar 2007 21:03:49 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Stephane Eranian <eranian@hpl.hp.com>, Ingo Molnar <mingo@elte.hu>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
References: <46099709.2000304@goop.org>
In-Reply-To: <46099709.2000304@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703282103.50191.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 00:13, Jeremy Fitzhardinge wrote:
> smp_call_function and smp_call_function_single are almost complete
> duplicates of the same logic.  This patch combines them by
> implementing them in terms of the more general
> smp_call_function_mask().

I think I got those already.

-Andi
