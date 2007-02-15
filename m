Return-Path: <linux-kernel-owner+w=401wt.eu-S1751416AbXBOAfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbXBOAfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 19:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbXBOAfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 19:35:18 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55309 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751416AbXBOAfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 19:35:17 -0500
X-Greylist: delayed 1330 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Feb 2007 19:35:17 EST
Date: Wed, 14 Feb 2007 16:13:06 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Nick Piggin <npiggin@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [patch] mm: NUMA replicated pagecache
In-Reply-To: <20070215001053.GB29797@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0702141611300.4902@schroedinger.engr.sgi.com>
References: <20070213060924.GB20644@wotan.suse.de>
 <Pine.LNX.4.64.0702141057060.975@schroedinger.engr.sgi.com>
 <20070215001053.GB29797@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Nick Piggin wrote:

> But no arguments, this doesn't aim to do replication of the same virtual
> address. If you did come up with such a scheme, however, you would still
> need a replicated pagecache for it as well.

Well there is always the manual road. Trigger something that scans over 
the address space and replicates pages that are not local. And yes we 
would still need your replication infrastructure. I would definitely like 
such a feature in the kernel.


