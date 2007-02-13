Return-Path: <linux-kernel-owner+w=401wt.eu-S1751406AbXBMX3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbXBMX3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbXBMX3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:29:34 -0500
Received: from gw.goop.org ([64.81.55.164]:52467 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbXBMX3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:29:33 -0500
Message-ID: <45D249D9.80407@goop.org>
Date: Tue, 13 Feb 2007 15:29:29 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable
 unsupported config options.
References: <20070213221729.772002682@goop.org> <20070213221830.542511707@goop.org> <45D24172.9020800@vmware.com>
In-Reply-To: <45D24172.9020800@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:
> I assume you plan to eventually get all this stuff working but just
> want to prevent configurations that the Xen paravirt-ops isn't ready
> for at the moment?
>
> Instead can you do it this way:
>
> config XEN
>     depends on PARAVIRT && !PREEMPT && HZ_100 && !DOUBLEFAULT && !KEXEC

That's a bit simpler code-wise, but it does make it pretty complex to
get everything just-so to even see the CONFIG_XEN option.

    J
