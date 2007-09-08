Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbXIGWLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbXIGWLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 18:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbXIGWLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 18:11:13 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:39438 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753731AbXIGWLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 18:11:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Iy5GJMaZ8G5dDbwZlAIrHwN3/IbPT6sTh1PWcmeIIWdasDSXLLG8hptjHV4Sp1TiHSLpA0jrpbeuti70o4jwF40/RrqNqUTnYDigp8h9zjS+yV6gwYllr5fljeTv6ypmMmMi78RGYbicqPNH2P+k2SwDG9jbDzzvjMbii+v7nlQ=  ;
X-YMail-OSG: C27A.mIVM1mCRBdnwlVao6Nkc7Lzr0LrfAmSUSbEP0EJyJY02jblpRQDRGU5zPqHiCNgyBPXNA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: tbench regression - Why process scheduler has impact on tbench and why small per-cpu slab (SLUB) cache creates the scenario?
Date: Sat, 8 Sep 2007 18:08:42 +1000
User-Agent: KMail/1.9.5
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
References: <1188953218.26438.34.camel@ymzhang> <1188969725.26438.46.camel@ymzhang> <Pine.LNX.4.64.0709050006330.7567@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709050006330.7567@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709081808.42421.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2007 17:07, Christoph Lameter wrote:
> On Wed, 5 Sep 2007, Zhang, Yanmin wrote:
> > > slub_max_order=3 slub_min_objects=8
> >
> > I tried this approach. The testing result showed 2.6.23-rc4 is about
> > 2.5% better than 2.6.22. It really resovles the issue.
>
> Note also that the configuration you tried is the way SLUB is configured
> in Andrew's tree.

It still doesn't sound like it is competitive with SLAB at the same sizes.
What's the problem?

