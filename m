Return-Path: <linux-kernel-owner+w=401wt.eu-S933587AbXCPL6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbXCPL6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933584AbXCPL6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:58:32 -0400
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:7068 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933587AbXCPL6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:58:32 -0400
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Fri, 16 Mar 2007 11:58:19 +0000
Subject: Re: [Xen-devel] Re: [patch 21/26] Xen-paravirt_ops: Use the hvc
 console infrastructure for Xen console
From: Keir Fraser <keir@xensource.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Keir Fraser <keir@xensource.com>
CC: Wright <chrisw@sous-sol.org>, <virtualization@lists.osdl.org>,
       <xen-devel@lists.xensource.com>, Andi Kleen <ak@muc.de>,
       <Chris@smtp.osdl.org>, Ingo Molnar <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, Keir Fraser <Keir.Fraser@xensource.com>
Message-ID: <C22036DB.BA67%keir@xensource.com>
Thread-Topic: [Xen-devel] Re: [patch 21/26] Xen-paravirt_ops: Use the hvc
 console infrastructure for Xen console
Thread-Index: AcdnwmNCoft8fNO1EduhtwAX8io7RQ==
In-Reply-To: <20070316034123.9de92632.akpm@linux-foundation.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/3/07 11:41, "Andrew Morton" <akpm@linux-foundation.org> wrote:

>> It's needed for writing data /after/ reading the consumer index that shows
>> you have space to write. Looking through xenbus_comms.c I think all the
>> barriers are correct except there is a spurious extra mb() in xb_read(),
>> where there is a later rmb() which is sufficient by itself. All the others
>> have a purpose.
>> 
> 
> If Ingo couldn't work this out from reading the code then nobody else can,
> and we have a maintainability problem which can only be solved with
> adequate commenting.

Agreed. I've fixed up the commenting, removed the spurious mb(), and I just
need Jeremy to merge that change into the Xen pv_ops patchset. :-)

 -- Keir

