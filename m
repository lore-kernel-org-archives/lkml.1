Return-Path: <linux-kernel-owner+w=401wt.eu-S932976AbXBPHIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976AbXBPHIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932975AbXBPHIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:08:04 -0500
Received: from gw.goop.org ([64.81.55.164]:41374 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbXBPHID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:08:03 -0500
Message-ID: <45D55852.9000103@goop.org>
Date: Thu, 15 Feb 2007 23:08:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Jan Beulich <JBeulich@novell.com>
Subject: Re: [patch 12/21] Xen-paravirt: Allocate and free vmalloc areas
References: <20070216022449.739760547@goop.org>	<20070216022531.417300365@goop.org> <20070215224322.5c73d8e9.akpm@linux-foundation.org>
In-Reply-To: <20070215224322.5c73d8e9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> This won't work when CONFIG_PREEMPT=y.  The pagefault handler will see
> in_atomic() and will scram.
>   

Is there some other way to get the pagetable populated for the address
range?

    J
