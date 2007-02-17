Return-Path: <linux-kernel-owner+w=401wt.eu-S1946775AbXBQPJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946775AbXBQPJG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 10:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946776AbXBQPJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 10:09:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946775AbXBQPJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 10:09:05 -0500
Message-ID: <45D71A00.5080104@redhat.com>
Date: Sat, 17 Feb 2007 10:06:40 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
CC: Zachary Amsden <zach@vmware.com>, Keir Fraser <keir@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com,
       Christian Limpach <Christian.Limpach@xensource.com>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Hand <steven.hand@cl.cam.ac.uk>, linux-kernel@vger.kernel.org,
       Ian Pratt <Ian.Pratt@xensource.com>
Subject: Re: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config	options
 and disableunsupported config options.
References: <C1FBAFD7.99AB%keir@xensource.com> <45D62759.7080006@vmware.com> <45D63255.2070801@vmware.com>
In-Reply-To: <45D63255.2070801@vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:

> Yes, and regardless of whether you run your periodic timer slower than 
> HZ, calibrating time in a VM is always difficult due to the fact the 
> kernel is time sharing the physical cpu.  Why not just ask the 
> underlying hypervisor?

Upstream Xen does just that.

I'm guessing we'll want something similar for KVM paravirt.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
