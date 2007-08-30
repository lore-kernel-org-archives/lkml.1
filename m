Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbXH3BbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbXH3BbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 21:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758708AbXH3BbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 21:31:07 -0400
Received: from h151.mvista.com ([63.81.120.158]:44637 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758360AbXH3BbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 21:31:06 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: eranian@hpl.hp.com
Cc: B.Steinbrink@gmx.de, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20070829212451.GC4810@frankl.hpl.hp.com>
References: <20070827175431.GD784@frankl.hpl.hp.com>
	 <1188237331.2435.255.camel@dhcp193.mvista.com>
	 <20070827225555.GI784@frankl.hpl.hp.com>
	 <1188256074.2435.272.camel@dhcp193.mvista.com>
	 <20070828091217.GA1645@frankl.hpl.hp.com>
	 <1188311684.2435.288.camel@dhcp193.mvista.com>
	 <20070828170556.GI1645@frankl.hpl.hp.com>
	 <1188325835.2435.317.camel@dhcp193.mvista.com>
	 <20070828194636.GB2814@frankl.hpl.hp.com>
	 <1188332024.2435.328.camel@dhcp193.mvista.com>
	 <20070829212451.GC4810@frankl.hpl.hp.com>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 18:21:59 -0700
Message-Id: <1188436919.26038.27.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 14:24 -0700, Stephane Eranian wrote:


> Now on Core Duo, there is no PEBS anyway, so it is okay to use counter 0
> for NMI. The problem is that the detection code in perfctr-watchdog.c
> treats a Core Duo and a Core 2 Duo the same way as they both have the
> X86_FEATURE_ARCH_PERFMON bit set.
> 
> I have attached a patch with handle the case of the Core Duo. Unfortunately,
> I do not own one so I cannot test it. I would appreciate if you could
> try re-applying my counter 0 -> 1 patch + this new one to see if you
> have the problem with the NMI getting stuck.

I tested your patch .. The system doesn't hang, but the NMI seems to
disappear .. The check_nmi_watchdog() is not called, and the NMI never
actually starts firing .. Is that what you had intended?

Daniel

