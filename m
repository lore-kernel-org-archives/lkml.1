Return-Path: <linux-kernel-owner+w=401wt.eu-S1750713AbXBPLKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750713AbXBPLKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 06:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbXBPLKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 06:10:13 -0500
Received: from 207.47.60.150.static.nextweb.net ([207.47.60.150]:19698 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbXBPLKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 06:10:12 -0500
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Fri, 16 Feb 2007 11:10:08 +0000
Subject: Re: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and free
 vmalloc areas
From: Keir Fraser <keir@xensource.com>
To: Andi Kleen <ak@muc.de>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zach@vmware.com>, <xen-devel@lists.xensource.com>,
       Ian Pratt <ian.pratt@xensource.com>, <linux-kernel@vger.kernel.org>,
       Jan Beulich <JBeulich@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Message-ID: <C1FB4190.98FA%keir@xensource.com>
Thread-Topic: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and
 free vmalloc areas
Thread-Index: AcdRuwSGQz8iHb2uEduvqQAX8io7RQ==
In-Reply-To: <20070216091843.GB28196@muc.de>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




On 16/2/07 09:18, "Andi Kleen" <ak@muc.de> wrote:

>> It's for populating the pagetable in a vmalloc area.  There's magic in
> 
> If the lazy setup doesn't work for you you can always call vmalloc_sync()
> early.

vmalloc_sync_all()? That's a great idea. We can put that in alloc_vm_area()
and kill {lock,unlock}_vm_area() which is a nice interface simplification.

 Thanks!
 Keir

