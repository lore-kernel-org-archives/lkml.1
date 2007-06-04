Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbXFDPIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbXFDPIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXFDPI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:08:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:52403 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbXFDPI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=q2bIK6bs2mdz0S+2WbP0T5ImCHD6YVy0t3aLDiV9wyYLF7/Wh6ktcxmWREiYBwW4D3Hz5ASETccaUBfaMM9JrUMK80x+9PZSdDh14tenXp7ahlOUu5j1eCDXSbqGu2Z8mf24dO/pHr6guyKQE7qSAG8gwlVkcIJONA7xDNjXnuU=
Message-ID: <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com>
Date: Mon, 4 Jun 2007 18:08:25 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jeremy@goop.org
In-Reply-To: <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
	 <20070601204141.f84ad72f.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
	 <20070601213117.1178e8e0.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 12ca1220cc8e26ab
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Andrew Morton wrote:
> > They are different instances which happen to have the same length (zero).

On 6/2/07, Christoph Lameter <clameter@sgi.com> wrote:
> I guess one could use the slab allocators as a type of reservation
> ticket generator with zero sized objects. Hmmm.... But is that really a
> useful thing to do?

Can someone remind me why we can't do what mm/slab.c does for
zero-size allocations in slub too?
