Return-Path: <linux-kernel-owner+w=401wt.eu-S1423188AbXBUWRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423188AbXBUWRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423190AbXBUWRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:17:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:37136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423189AbXBUWRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:17:10 -0500
From: Andi Kleen <ak@suse.de>
To: virtualization@lists.osdl.org
Subject: Re: [patch 05/24] Xen-paravirt_ops: Add pagetable accessors to pack and unpack pagetable entries
Date: Wed, 21 Feb 2007 23:15:12 +0100
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chris Wright <chrisw@sous-sol.org>,
       xen-devel@lists.xensource.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070221205254.169835700@goop.org> <20070221205322.869165491@goop.org>
In-Reply-To: <20070221205322.869165491@goop.org>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702212315.12883.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 February 2007 21:52, Jeremy Fitzhardinge wrote:
> Add a set of accessors to pack, unpack and modify page table entries
> (at all levels).  This allows a paravirt implementation to control the
> contents of pgd/pmd/pte entries.  For example, Xen uses this to
> convert the (pseudo-)physical address into a machine address when
> populating a pagetable entry, and converting back to pphys address
> when an entry is read.

Do you have some lmbench numbers before/after this change? 
iirc at least fork and exit do a lot of pte accesses in various forms.
If it's measurable it might be needed to patch those for the native case.

-Andi
