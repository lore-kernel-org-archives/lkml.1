Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbXGZHIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbXGZHIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 03:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761662AbXGZHIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 03:08:24 -0400
Received: from mail-04.jhb.wbs.co.za ([196.2.97.3]:14098 "EHLO
	mail-04.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762669AbXGZHIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 03:08:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAPTkp0bEHh/E/2dsb2JhbAA
From: Bongani Hlope <bhlope@mweb.co.za>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: updatedb
Date: Thu, 26 Jul 2007 09:08:02 +0200
User-Agent: KMail/1.9.7
Cc: Robert Deaton <false.hopes@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com> <200707260839.51407.bhlope@mweb.co.za> <46A845BB.9080503@gmail.com>
In-Reply-To: <46A845BB.9080503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707260908.02781.bhlope@mweb.co.za>
X-Original-Subject: Re: updatedb
X-Scan-Signature: 38083ec5f3d1ed275db7b5d0a2c67615
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007 08:56:59 Rene Herman wrote:
> On 07/26/2007 08:39 AM, Bongani Hlope wrote:
> > On Thursday 26 July 2007 05:59:53 Rene Herman wrote:
> >> So what's happening? If you sit down with a copy op "top" in one
> >> terminal and updatedb in another, what does it show?
> >
> > Just tested that, there's a steady increase in the useage of buff
>
> Great. Now concentrate on the "swpd" column, as it's the only thing
> relevant here. The fact that an updatedb run fills/replaces caches is
> completely and utterly unsurprising and not something swap-prefetch helps
> with. The only thing it does is bring back stuff from _swap_.
>

;)

I have 2Gb of RAM and I never ever touched swap on all my work loads. I was 
just showing the behavior of updatedb on my desktop. I have never even looked 
at the swap-prefetch patch (for obvious reasons). I think people should also 
look at their /proc/sys/vm/overcommit_ratio
