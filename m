Return-Path: <linux-kernel-owner+w=401wt.eu-S1751486AbXBNBYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbXBNBYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbXBNBYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:24:14 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43056 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbXBNBYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:24:13 -0500
Message-ID: <45D2649D.4080508@vmware.com>
Date: Tue, 13 Feb 2007 17:23:41 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 05/21] Xen-paravirt: paravirt_ops: allocate a fixmap slot
References: <20070213221729.772002682@goop.org> <20070213221829.845132535@goop.org>
In-Reply-To: <20070213221829.845132535@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Feb 2007 01:24:12.0785 (UTC) FILETIME=[D58ECE10:01C74FD6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2007 02:17 PM, Jeremy Fitzhardinge wrote:
> Allocate a fixmap slot for use by a paravirt_ops implementation.  Xen
> uses this to map the hypervisor's shared info page, which doesn't have
> a pseudo-physical page number, and therefore can't be mapped
> ordinarily.
> 

Why doesn't Xen allocate the shared_info page from the pseudo-physical 
space?  Doesn't it already have to steal pages from the pseudo-physical 
space for e.g. initial page tables, console, etc?  Why not do the same 
for shared_info, and then you don't need a reserve the fixmap slot.

Dan
