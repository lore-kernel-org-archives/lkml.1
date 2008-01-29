Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYA3FV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYA3FV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYA3FVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:21:19 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:56683 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751391AbYA3FVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:21:18 -0500
Date: Tue, 29 Jan 2008 19:20:19 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH powerpc] Fake NUMA emulation for PowerPC (Take 3)
Message-ID: <20080129135019.GC16034@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Michael Ellerman <michael@ellerman.id.au>,
	Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop> <1200634493.7806.0.camel@concordia.ozlabs.ibm.com> <1200635099.7806.3.camel@concordia.ozlabs.ibm.com> <20080126071339.GA25328@balbir.in.ibm.com> <18332.28991.658933.763115@cargo.ozlabs.ibm.com> <20080128125206.GC4330@balbir.in.ibm.com> <1201611898.26410.7.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1201611898.26410.7.camel@concordia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Ellerman <michael@ellerman.id.au> [2008-01-30 00:04:58]:

> Why do you check !p after assigning to nid? I assume it's because we
> might have reached the end of the command line, ie. p == NULL, but we're
> still adding memory to the last node? If so it's a it's a little subtle
> and deserves a comment I think.
>

The reason that we check for !p after assigning node id is that, in
case we create fake NUMA nodes, we want nid to be the fake numa node
id and not the real node id or in the non NUMA case, node id 0.

The if (!p) checks to see if we do have more arguments to parse.
 
> Otherwise this looks pretty good.
> 

Thanks!

> cheers
> 
> -- 
> Michael Ellerman
> OzLabs, IBM Australia Development Lab
> 
> wwweb: http://michael.ellerman.id.au
> phone: +61 2 6212 1183 (tie line 70 21183)
> 
> We do not inherit the earth from our ancestors,
> we borrow it from our children. - S.M.A.R.T Person



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
