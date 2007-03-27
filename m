Return-Path: <linux-kernel-owner+w=401wt.eu-S934237AbXC0WqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237AbXC0WqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934247AbXC0WqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:46:12 -0400
Received: from gw.goop.org ([64.81.55.164]:44390 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934237AbXC0WqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:46:11 -0400
Message-ID: <46099EB0.8000900@goop.org>
Date: Tue, 27 Mar 2007 15:46:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Stephane Eranian <eranian@hpl.hp.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Simplify smp_call_function*() by using common implementation
References: <46099709.2000304@goop.org> <20070327154357.f9335623.rdunlap@xenotime.net>
In-Reply-To: <20070327154357.f9335623.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>                                               func() or <what>??
>       and what does "nearly ready" mean?
>   

Sorry, I forgot to include your doc updates from last time.

"nearly ready" means that its just about to call the function, but
hasn't necessarily done so.

    J
