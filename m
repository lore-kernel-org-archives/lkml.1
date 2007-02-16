Return-Path: <linux-kernel-owner+w=401wt.eu-S1750814AbXBPLej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750814AbXBPLej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 06:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbXBPLej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 06:34:39 -0500
Received: from ns2.suse.de ([195.135.220.15]:41988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbXBPLej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 06:34:39 -0500
From: Andi Kleen <ak@suse.de>
To: virtualization@lists.osdl.org
Subject: Re: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and free vmalloc areas
Date: Fri, 16 Feb 2007 12:34:23 +0100
User-Agent: KMail/1.9.5
Cc: Keir Fraser <keir@xensource.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Pratt <ian.pratt@xensource.com>, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Beulich <JBeulich@novell.com>
References: <C1FB4190.98FA%keir@xensource.com>
In-Reply-To: <C1FB4190.98FA%keir@xensource.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702161234.24034.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 February 2007 12:10, Keir Fraser wrote:
> 
> On 16/2/07 09:18, "Andi Kleen" <ak@muc.de> wrote:
> 
> >> It's for populating the pagetable in a vmalloc area.  There's magic in
> > 
> > If the lazy setup doesn't work for you you can always call vmalloc_sync()
> > early.
> 
> vmalloc_sync_all()? 

Yes.

Credit goes to Jan for writing it originally.

-Andi

