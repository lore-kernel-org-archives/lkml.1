Return-Path: <linux-kernel-owner+w=401wt.eu-S1423446AbXBPJSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423446AbXBPJSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423452AbXBPJSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:18:46 -0500
Received: from colin.muc.de ([193.149.48.1]:3505 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423446AbXBPJSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:18:45 -0500
Date: 16 Feb 2007 10:18:43 +0100
Date: Fri, 16 Feb 2007 10:18:43 +0100
From: Andi Kleen <ak@muc.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Jan Beulich <JBeulich@novell.com>
Subject: Re: [patch 12/21] Xen-paravirt: Allocate and free vmalloc areas
Message-ID: <20070216091843.GB28196@muc.de>
References: <20070216022449.739760547@goop.org> <20070216022531.417300365@goop.org> <20070215224322.5c73d8e9.akpm@linux-foundation.org> <45D55852.9000103@goop.org> <20070215232447.5ee67f50.akpm@linux-foundation.org> <45D55DB1.7040002@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D55DB1.7040002@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's for populating the pagetable in a vmalloc area.  There's magic in

If the lazy setup doesn't work for you you can always call vmalloc_sync()
early.

-Andi
