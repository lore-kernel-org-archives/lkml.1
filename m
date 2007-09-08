Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbXIHH2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbXIHH2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXIHH23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:28:29 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:39918 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752816AbXIHH22 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:28:28 -0400
Date: Sat, 8 Sep 2007 03:23:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] Linux Kernel Markers - Port SPU to markers
Message-ID: <20070908072317.GA16854@Krystal>
References: <20070906200733.194442762@polymtl.ca> <20070906200827.452767571@polymtl.ca> <20070908070438.GA1819@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070908070438.GA1819@martell.zuzino.mipt.ru>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 03:21:14 up 40 days,  7:40,  4 users,  load average: 0.07, 0.33, 0.39
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexey Dobriyan (adobriyan@gmail.com) wrote:
> On Thu, Sep 06, 2007 at 04:07:39PM -0400, Mathieu Desnoyers wrote:
> > Andrew, any chance to get this into -mm ASAP so we can have it in
> > 2.6.24?
> > 
> > Just in case anyone wonders what this is usefulfor I've ported my
> > hacking spu tracing code to it, and if markers get in I'd push a cleaned
> > up version of this in the tree of the benefit of everyone trying to
> > follow what's going on in the spufs code.  Similarly I'd like to port
> > the xfs tracing code over to it which is very helpful in trying to
> > debug filesystem issues.
> > 
> > Note that in this patch the actual logging code is rather nasty
> > hand-crafted code lifted from the tcp probe in tree which would benefit
> > of going away in favour of more general tracing code aswell.
> > 
> > Changelog:
> > - Porting to 2.6.23-rc4-mm1 gave a reject (a trace point location disappeared)
> >   from spufs_ps_nopfn() : spufs_ps_nopfn__sleep and spufs_ps_nopfn__wake.
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> Where are Christoph's attributions?

I realized only after sending this patch set that the 

From: Christoph Hellwig <hch@infradead.org>

Has somehow been stripped off from the patch header.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
