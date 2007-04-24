Return-Path: <linux-kernel-owner+w=401wt.eu-S1030780AbXDXVNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030780AbXDXVNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030241AbXDXVNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:13:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:53113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965280AbXDXVNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:13:09 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 04/25] xen: Add XEN config options
Date: Tue, 24 Apr 2007 21:45:06 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>
References: <20070423215638.563901986@goop.org> <200704240100.31011.ak@suse.de> <462D3D31.1090702@goop.org>
In-Reply-To: <462D3D31.1090702@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704242145.06915.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Shouldn't this be after the change that adds arch/i386/xen/Kconfig?
> >
> > Otherwise you break bisects
> >   
> 
> It should be OK.  The series should build and run at each patch (though
> I have to admit I haven't tested this).  In general I've been adding
> config options for each feature as the feature itself is added.

But i don't see anything that creates arch/i386/xen before this?

-Andi

