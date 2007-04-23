Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbXDWXCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbXDWXCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbXDWXCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:02:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:46185 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbXDWXCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:02:08 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 04/25] xen: Add XEN config options
Date: Tue, 24 Apr 2007 01:00:30 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>
References: <20070423215638.563901986@goop.org> <20070423215709.990824532@goop.org>
In-Reply-To: <20070423215709.990824532@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704240100.31011.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 23:56:42 Jeremy Fitzhardinge wrote:
> The XEN config option enables the Xen paravirt_ops interface, which is
> installed when the kernel finds itself running under Xen.
> 
> Xen is no longer a sub-architecture, so the X86_XEN subarch config
> option has gone.
> 
> Xen is currently incompatible with PREEMPT, but this is fixed up later
> in the series.

Shouldn't this be after the change that adds arch/i386/xen/Kconfig?

Otherwise you break bisects

-Andi
