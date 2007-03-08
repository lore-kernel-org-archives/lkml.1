Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXCHSZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXCHSZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932489AbXCHSZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:25:19 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:50059 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463AbXCHSZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:25:17 -0500
Date: Thu, 8 Mar 2007 10:24:56 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Daniel Arai <arai@vmware.com>
Cc: tglx@linutronix.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Message-ID: <20070308182456.GH19575@sequoia.sous-sol.org>
References: <45EEF966.6060902@goop.org> <Line.LNX.4.64.0703071304080.1851@d.namei> <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <1173313373.24738.937.camel@localhost.localdomain> <45EF6077.9090302@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EF6077.9090302@vmware.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Arai (arai@vmware.com) wrote:
> There's no good way to override __send_IPI_shortcut.  I suppose we could add 
> paravirt ops for __send_IPI_shortcut and every other op that touches the APIC. 

While that's basically what we did in Xen, it would make more sense to
build it into genapic which would give us one common abstraction to base
from.  We should avoid adding pv_ops when existing infrastructure exists.

thanks,
-chris
