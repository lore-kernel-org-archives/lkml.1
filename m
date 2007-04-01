Return-Path: <linux-kernel-owner+w=401wt.eu-S965116AbXDAUxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965116AbXDAUxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 16:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965095AbXDAUxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 16:53:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:50405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965109AbXDAUxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 16:53:40 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: tglx@linutronix.de
Subject: Re: [RFC PATCH 0/5] x86_64: enable clockevents and dynticks
Date: Sun, 1 Apr 2007 22:53:20 +0200
User-Agent: KMail/1.9.5
Cc: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
References: <20070331083149.997762000@sous-sol.org> <1175419332.28263.67.camel@localhost.localdomain>
In-Reply-To: <1175419332.28263.67.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704012253.20834.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Have you checked, if we could share the code between i386 and x86_64 at
> least for PIT and HPET. I'm not sure about the local APIC, but I think
> it might be doable as well.

Not for PIT. I don't want all the broken ancient hardware workarounds on x86-64.
HPET might be doable, but would need quite some work.

-Andi
